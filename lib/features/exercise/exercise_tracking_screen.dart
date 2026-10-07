import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/logging/app_logger.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/exercise_library.dart';
import '../../domain/entities/provenance.dart';
import '../../domain/services/exercise_tracker.dart';
import '../../domain/services/posture_engine.dart' show PostureView;
import '../../l10n/app_localizations.dart';
import '../../ml/inference/frame_pipeline.dart';
import '../../ml/pose/pose_estimator.dart';
import '../../shared/widgets/async_view.dart';
import '../camera/camera_providers.dart';
import '../camera/camera_source.dart';
import '../camera/camera_stage.dart';
import '../camera/portrait_lock.dart';
import '../health/health_providers.dart';
import 'exercise_library_screen.dart';

enum _Phase { setup, ready, countdown, active, summary }

/// Camera-guided exercise (spec §18–19): counts reps or times holds from
/// on-device pose landmarks and gives live form cues. Frames are analyzed
/// in memory and discarded.
class ExerciseTrackingScreen extends ConsumerWidget {
  const ExerciseTrackingScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) => AsyncView(
        value: ref.watch(exerciseCatalogProvider),
        data: (all) {
          final e = all.where((x) => x.id == id && x.trackable).firstOrNull;
          if (e == null) return const Scaffold(body: SizedBox.shrink());
          return _Tracking(exercise: e);
        },
      );
}

class _Tracking extends ConsumerStatefulWidget {
  const _Tracking({required this.exercise});

  final LibraryExercise exercise;

  static const countdownSeconds = 5;

  @override
  ConsumerState<_Tracking> createState() => _TrackingState();
}

class _TrackingState extends ConsumerState<_Tracking> {
  late final CameraSource _camera = ref.read(cameraSourceProvider);
  late final AppLifecycleListener _lifecycle;
  late ExerciseTracker _tracker = ExerciseTracker(widget.exercise.pattern!);
  FramePipeline? _pipeline;
  _Phase _phase = _Phase.setup;
  CameraLens _lens = CameraLens.front;
  PoseDetected? _pose;
  TrackerState _state = TrackerState.initial;
  Timer? _countdownTimer;
  int _countdown = 0;
  DateTime? _startedAt;
  Duration _elapsed = Duration.zero;
  bool _saved = false;

  bool get _hold => widget.exercise.pattern!.mode == TrackingMode.hold;

  @override
  void initState() {
    super.initState();
    PortraitLock.enter();
    _lifecycle = AppLifecycleListener(onHide: () {
      if (_phase == _Phase.active) _finish();
      _stopCamera();
    });
  }

  @override
  void dispose() {
    PortraitLock.exit();
    _countdownTimer?.cancel();
    _lifecycle.dispose();
    _pipeline?.close();
    _camera.stop();
    super.dispose();
  }

  Future<void> _startCamera() async {
    _pipeline?.close();
    final mode = ref.read(cameraPowerModeProvider);
    final pipeline = FramePipeline(
      targetFps: mode.analysisFps,
      estimator: ref.read(poseEstimatorProvider),
      onStatus: _onStatus,
    );
    _pipeline = pipeline;
    setState(() {
      _phase = _Phase.ready;
      _tracker = ExerciseTracker(widget.exercise.pattern!);
      _state = TrackerState.initial;
      _saved = false;
    });
    await _camera.start(_lens, mode, pipeline.process);
  }

  Future<void> _stopCamera() async {
    _pipeline?.close();
    await _camera.stop();
  }

  void _onStatus(PipelineStatus s) {
    if (!mounted) return;
    final pose = s.pose is PoseDetected ? s.pose as PoseDetected : null;
    final at = s.frameTime ?? DateTime.now();
    TrackerState next = _state;
    if (_phase == _Phase.active) {
      next = _tracker.update(pose, at);
      final target = widget.exercise.target;
      if (target != null &&
          (_hold ? next.holdSeconds >= target : next.reps >= target)) {
        _state = next;
        _finish();
        return;
      }
    }
    setState(() {
      _pose = pose;
      _state = next;
      if (_startedAt != null && _phase == _Phase.active) {
        _elapsed = DateTime.now().difference(_startedAt!);
      }
    });
  }

  void _begin() {
    _countdownTimer?.cancel();
    setState(() {
      _phase = _Phase.countdown;
      _countdown = _Tracking.countdownSeconds;
    });
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return t.cancel();
      if (_countdown <= 1) {
        t.cancel();
        setState(() {
          _phase = _Phase.active;
          _startedAt = DateTime.now();
          _elapsed = Duration.zero;
        });
      } else {
        setState(() => _countdown--);
      }
    });
  }

  void _finish() {
    _countdownTimer?.cancel();
    if (_startedAt != null) _elapsed = DateTime.now().difference(_startedAt!);
    _stopCamera();
    setState(() => _phase = _Phase.summary);
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final messenger = ScaffoldMessenger.of(context);
    final e = widget.exercise;
    try {
      await ref.read(exerciseRepositoryProvider).add(
            name: LibraryExercise.pick(e.name, lang),
            category: e.category,
            durationMinutes: (_elapsed.inSeconds / 60).ceil().clamp(1, 1440),
            reps: _hold ? null : _state.reps,
            performedAt: _startedAt ?? ref.read(clockProvider)(),
            source: DataSource.cameraDerived,
          );
      setState(() => _saved = true);
      messenger.showSnackBar(SnackBar(content: Text(l10n.savedToLog)));
    } catch (err, st) {
      AppLogger.error('exercise.save', err, st);
      messenger.showSnackBar(SnackBar(content: Text(l10n.recordSaveError)));
    }
  }

  String _guidance(AppLocalizations l10n) {
    if (_phase == _Phase.active || _phase == _Phase.countdown) {
      final cue = _state.cue;
      if (cue != null) return cueText(l10n, cue);
      if (_hold && _phase == _Phase.active && !_state.inPosition) {
        return l10n.cueGetIntoPosition;
      }
      return _phase == _Phase.countdown ? l10n.postureStepBack : l10n.cueKeepGoing;
    }
    return _pose == null ? l10n.poseNoPerson : l10n.trackingReady;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final e = widget.exercise;
    final target = e.target;

    return Scaffold(
      appBar: AppBar(title: Text(LibraryExercise.pick(e.name, lang))),
      body: ValueListenableBuilder<CameraSourceState>(
        valueListenable: _camera.state,
        builder: (context, cam, _) => ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: switch (_phase) {
            _Phase.setup => [
                Text(e.view == PostureView.side
                    ? l10n.trackingSetupSide
                    : l10n.trackingSetupFront),
                const SizedBox(height: AppSpacing.sm),
                Text(_hold
                    ? l10n.trackingTargetHold(target ?? 30)
                    : l10n.trackingTargetReps(target ?? 10)),
                const SizedBox(height: AppSpacing.lg),
                SegmentedButton<CameraLens>(
                  segments: [
                    ButtonSegment(value: CameraLens.front, label: Text(l10n.lensFront)),
                    ButtonSegment(value: CameraLens.back, label: Text(l10n.lensBack)),
                  ],
                  selected: {_lens},
                  showSelectedIcon: false,
                  onSelectionChanged: (s) => setState(() => _lens = s.single),
                ),
                const SizedBox(height: AppSpacing.lg),
                FilledButton.icon(
                  onPressed: _startCamera,
                  icon: const Icon(Icons.videocam_outlined),
                  label: Text(l10n.cameraStart),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(LibraryExercise.pick(e.safety, lang),
                    style: theme.textTheme.bodySmall),
              ],
            _Phase.ready || _Phase.countdown || _Phase.active => [
                if (cam.problem != null)
                  CameraProblemCard(problem: cam.problem!, onRetry: _startCamera)
                else ...[
                  CameraStage(
                    camera: _camera,
                    state: cam,
                    pose: _pose,
                    guidance: _guidance(l10n),
                    countdown: _phase == _Phase.countdown ? _countdown : null,
                    overlay: _phase == _Phase.active
                        ? _Counter(
                            label: _hold
                                ? l10n.holdSecondsValue(_state.holdSeconds.floor())
                                : '${_state.reps}',
                            sub: _hold
                                ? l10n.trackingOfSeconds(target ?? 30)
                                : l10n.trackingOfReps(target ?? 10),
                          )
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (_phase == _Phase.active)
                    FilledButton.icon(
                      onPressed: _finish,
                      icon: const Icon(Icons.stop),
                      label: Text(l10n.trackingFinish),
                    )
                  else if (_phase == _Phase.ready)
                    FilledButton.icon(
                      onPressed: cam.running ? _begin : null,
                      icon: const Icon(Icons.play_arrow),
                      label: Text(l10n.trackingStart),
                    ),
                ],
              ],
            _Phase.summary => [
                Text(l10n.trackingSummaryTitle, style: theme.textTheme.titleLarge),
                const SizedBox(height: AppSpacing.md),
                Card(
                  child: Column(children: [
                    ListTile(
                      leading: Icon(_hold ? Icons.timer_outlined : Icons.repeat),
                      title: Text(_hold ? l10n.trackingHoldTime : l10n.trackingRepsDone),
                      trailing: Text(
                        _hold
                            ? l10n.holdSecondsValue(_state.holdSeconds.floor())
                            : '${_state.reps}',
                        style: theme.textTheme.headlineSmall,
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.schedule),
                      title: Text(l10n.durationLabel),
                      trailing: Text(l10n.holdSecondsValue(_elapsed.inSeconds)),
                    ),
                  ]),
                ),
                if (target != null &&
                    (_hold ? _state.holdSeconds >= target : _state.reps >= target))
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.sm),
                    child: Text(l10n.trackingTargetReached,
                        style: theme.textTheme.titleMedium),
                  ),
                const SizedBox(height: AppSpacing.sm),
                Text(l10n.trackingCountNote, style: theme.textTheme.bodySmall),
                const SizedBox(height: AppSpacing.lg),
                Row(children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _saved ? null : _save,
                      icon: Icon(_saved ? Icons.check : Icons.save_outlined),
                      label: Text(_saved ? l10n.postureSavedShort : l10n.saveToLog),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _startCamera,
                      icon: const Icon(Icons.replay),
                      label: Text(l10n.postureRetake),
                    ),
                  ),
                ]),
                const SizedBox(height: AppSpacing.sm),
                TextButton(
                  onPressed: () => context.pop(),
                  child: Text(l10n.trackingDone),
                ),
              ],
          },
        ),
      ),
    );
  }
}

class _Counter extends StatelessWidget {
  const _Counter({required this.label, required this.sub});

  final String label;
  final String sub;

  @override
  Widget build(BuildContext context) => Semantics(
        liveRegion: true,
        label: '$label $sub',
        child: ExcludeSemantics(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(children: [
              Text(label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 44,
                      fontWeight: FontWeight.w700)),
              Text(sub, style: const TextStyle(color: Colors.white, fontSize: 13)),
            ]),
          ),
        ),
      );
}

String cueText(AppLocalizations l10n, FormCue c) => switch (c) {
      FormCue.stepIntoView => l10n.cueStepIntoView,
      FormCue.goLower => l10n.cueGoLower,
      FormCue.kneesOverToes => l10n.cueKneesOverToes,
      FormCue.chestUp => l10n.cueChestUp,
      FormCue.raiseHigher => l10n.cueRaiseHigher,
      FormCue.raiseEvenly => l10n.cueRaiseEvenly,
      FormCue.liftKneeHigher => l10n.cueLiftKneeHigher,
      FormCue.keepBodyStraight => l10n.cueKeepBodyStraight,
      FormCue.getIntoPosition => l10n.cueGetIntoPosition,
      FormCue.goodForm => l10n.cueGoodForm,
    };
