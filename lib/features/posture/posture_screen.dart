import 'dart:async';

import '../camera/camera_stage.dart';
import '../camera/portrait_lock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/logging/app_logger.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/body.dart';
import '../../domain/entities/provenance.dart';
import '../../domain/services/posture_engine.dart';
import '../../domain/services/posture_recommendations.dart';
import '../../l10n/app_localizations.dart';
import '../../ml/inference/frame_pipeline.dart';
import '../../ml/pose/pose_estimator.dart';
import '../../ml/preprocessing/frame_quality.dart';
import '../../shared/format/body_format.dart';
import '../../shared/widgets/provenance_chip.dart';
import '../camera/camera_check_screen.dart' show lightingLabel;
import '../camera/camera_providers.dart';
import '../camera/camera_source.dart';
import '../health/body_providers.dart';
import 'posture_labels.dart';
import 'posture_providers.dart';

enum _Phase { setup, live, countdown, capturing, result, failed }

/// Posture check (spec §15–17): live landmarks and guidance, a multi-frame
/// capture, then estimated alignment with confidence. Frames are analyzed
/// in memory and discarded.
class PostureScreen extends ConsumerStatefulWidget {
  const PostureScreen({super.key});

  static const captureTimeout = Duration(seconds: 15);

  /// Time to step back into position after tapping Analyze.
  static const countdownSeconds = 5;

  @override
  ConsumerState<PostureScreen> createState() => _PostureScreenState();
}

class _PostureScreenState extends ConsumerState<PostureScreen> {
  late final CameraSource _camera = ref.read(cameraSourceProvider);
  late final AppLifecycleListener _lifecycle;
  FramePipeline? _pipeline;
  _Phase _phase = _Phase.setup;
  CameraLens _lens = CameraLens.front;
  PoseDetected? _pose;
  PoseEstimation? _lastEstimation;
  PoseDetected? _previous;
  FrameAssessment? _assessment;
  LightingLevel? _lighting;
  PostureCapture? _capture;
  Timer? _timeout;
  Timer? _countdownTimer;
  int _countdown = 0;
  PostureResult? _result;
  PostureResult? _previousResult;
  FrameQualityIssue? _failure;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    PortraitLock.enter();
    _lifecycle = AppLifecycleListener(onHide: _stopCamera);
  }

  @override
  void dispose() {
    PortraitLock.exit();
    _timeout?.cancel();
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
      _phase = _Phase.live;
      _pose = null;
      _previous = null;
      _assessment = null;
      _result = null;
      _failure = null;
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
    final pose = s.pose;
    FrameAssessment? assessment;
    if (pose is PoseDetected) {
      assessment = PostureEngine.assess(pose, previous: _previous);
      _previous = pose;
    } else if (pose is LowQualityFrame) {
      assessment = FrameAssessment(issues: pose.issues);
    }
    final capture = _capture;
    if (_phase == _Phase.capturing && capture != null && assessment != null) {
      capture.add(assessment);
      if (capture.complete) _finishCapture();
    }
    setState(() {
      _lighting = s.lighting;
      _lastEstimation = pose;
      _pose = pose is PoseDetected ? pose : null;
      _assessment = assessment;
    });
  }

  /// Starts a countdown so the user can tap, then step back into place.
  void _analyze() {
    _countdownTimer?.cancel();
    setState(() {
      _phase = _Phase.countdown;
      _countdown = PostureScreen.countdownSeconds;
    });
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return t.cancel();
      if (_countdown <= 1) {
        t.cancel();
        _beginCapture();
      } else {
        setState(() => _countdown--);
      }
    });
  }

  void _beginCapture() {
    _capture = PostureCapture();
    _timeout?.cancel();
    _timeout = Timer(PostureScreen.captureTimeout, _finishCapture);
    setState(() => _phase = _Phase.capturing);
  }

  void _finishCapture() {
    _timeout?.cancel();
    final capture = _capture;
    if (capture == null || _phase != _Phase.capturing) return;
    final result = capture.result();
    _capture = null;
    // The most recent saved check with the same view, for comparison.
    _previousResult = (ref.read(postureHistoryProvider).value ?? const [])
        .map((s) => s.result)
        .where((r) => r.view == result?.view)
        .firstOrNull;
    _stopCamera(); // done with the camera; save battery and privacy
    setState(() {
      _result = result;
      _failure = result == null ? capture.mainIssue : null;
      _phase = result == null ? _Phase.failed : _Phase.result;
    });
  }

  Future<void> _save() async {
    final r = _result;
    if (r == null) return;
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);
    try {
      await ref.read(postureRepositoryProvider).save(r);
      setState(() => _saved = true);
      messenger.showSnackBar(SnackBar(content: Text(l10n.postureSaved)));
    } catch (e, st) {
      AppLogger.error('posture.save', e, st);
      messenger.showSnackBar(SnackBar(content: Text(l10n.recordSaveError)));
    }
  }

  String _guidance(AppLocalizations l10n) {
    if (_lighting != null &&
        _lighting != LightingLevel.good &&
        _lighting != LightingLevel.dim) {
      return lightingLabel(l10n, _lighting!);
    }
    final a = _assessment;
    switch (_lastEstimation) {
      case null:
        return l10n.cameraWaiting;
      case NoPersonDetected():
        return l10n.poseNoPerson;
      case PoseUnavailable(:final reason):
        return reason == UnavailableReason.modelNotInstalled
            ? l10n.poseModelRequired
            : l10n.poseAnalysisFailed;
      case LowQualityFrame() || PoseDetected():
        break;
    }
    if (a == null) return l10n.cameraWaiting;
    if (!a.usable) return l10n.poseGuidance(firstIssue(a.issues));
    return l10n.postureReady(l10n.viewLabel(a.view!));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.featurePosture),
        actions: [
          IconButton(
            tooltip: l10n.postureHistory,
            icon: const Icon(Icons.history),
            onPressed: () => context.push(AppRoutes.postureHistory),
          ),
        ],
      ),
      body: ValueListenableBuilder<CameraSourceState>(
        valueListenable: _camera.state,
        builder: (context, cam, _) => ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: switch (_phase) {
            _Phase.setup => [_Setup(
                lens: _lens,
                onLens: (l) => setState(() => _lens = l),
                onStart: _startCamera,
              )],
            _Phase.live || _Phase.countdown || _Phase.capturing => [
                if (cam.problem != null)
                  CameraProblemCard(problem: cam.problem!, onRetry: _startCamera)
                else ...[
                  CameraStage(
                    camera: _camera,
                    state: cam,
                    pose: _pose,
                    guidance: _guidance(l10n),
                    countdown: _phase == _Phase.countdown ? _countdown : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (_phase == _Phase.countdown)
                    Text(l10n.postureStepBack,
                        style: Theme.of(context).textTheme.titleMedium)
                  else if (_phase == _Phase.capturing) ...[
                    LinearProgressIndicator(value: _capture?.progress ?? 0),
                    const SizedBox(height: AppSpacing.sm),
                    Text(l10n.postureCapturing),
                  ] else
                    FilledButton.icon(
                      // Enabled as soon as the camera runs: the countdown
                      // gives time to step back into position.
                      onPressed: cam.running ? _analyze : null,
                      icon: const Icon(Icons.accessibility_new),
                      label: Text(l10n.postureAnalyze),
                    ),
                ],
              ],
            _Phase.failed => [
                _Failed(
                  issue: _failure,
                  onRetry: _startCamera,
                ),
              ],
            _Phase.result => [
                _ResultView(
                  result: _result!,
                  previous: _previousResult,
                  saved: _saved,
                  onSave: _save,
                  onRetake: _startCamera,
                ),
              ],
          },
        ),
      ),
    );
  }
}

class _Setup extends StatelessWidget {
  const _Setup({required this.lens, required this.onLens, required this.onStart});

  final CameraLens lens;
  final ValueChanged<CameraLens> onLens;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tips = [
      (Icons.phone_android, l10n.postureTipPhone),
      (Icons.straighten, l10n.postureTipDistance),
      (Icons.wb_sunny_outlined, l10n.postureTipLight),
      (Icons.checkroom_outlined, l10n.postureTipClothes),
      (Icons.threesixty, l10n.postureTipViews),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.postureIntro, style: theme.textTheme.bodyMedium),
        const SizedBox(height: AppSpacing.md),
        for (final (icon, text) in tips)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(icon),
            title: Text(text),
          ),
        const SizedBox(height: AppSpacing.md),
        SegmentedButton<CameraLens>(
          segments: [
            ButtonSegment(value: CameraLens.front, label: Text(l10n.lensFront)),
            ButtonSegment(value: CameraLens.back, label: Text(l10n.lensBack)),
          ],
          selected: {lens},
          showSelectedIcon: false,
          onSelectionChanged: (s) => onLens(s.single),
        ),
        const SizedBox(height: AppSpacing.lg),
        FilledButton.icon(
          onPressed: onStart,
          icon: const Icon(Icons.videocam_outlined),
          label: Text(l10n.cameraStart),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(l10n.postureDisclaimer, style: theme.textTheme.bodySmall),
      ],
    );
  }
}

class _Failed extends StatelessWidget {
  const _Failed({required this.issue, required this.onRetry});

  final FrameQualityIssue? issue;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            Icon(Icons.replay, size: 40, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: AppSpacing.md),
            Text(l10n.postureNotReliable,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.sm),
            Text(issue == null ? l10n.poseReposition : l10n.poseGuidance(issue!),
                textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(onPressed: onRetry, child: Text(l10n.actionRetry)),
          ],
        ),
      ),
    );
  }
}

class _ResultView extends ConsumerWidget {
  const _ResultView({
    required this.result,
    required this.previous,
    required this.saved,
    required this.onSave,
    required this.onRetake,
  });

  final PostureResult result;
  final PostureResult? previous;
  final bool saved;
  final VoidCallback onSave;
  final VoidCallback onRetake;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final goals = ref.watch(goalsProvider).value ?? const <GoalType>{};
    final library = ref.watch(exerciseLibraryProvider).value ?? const [];
    final recs = PostureRecommender.recommend(
      latest: result,
      library: library,
      previous: previous,
      postureGoal: goals.contains(GoalType.posture),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.postureResultTitle(l10n.viewLabel(result.view)),
            style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ProvenanceChip(source: result.source, confidence: result.confidence),
            Text(l10n.postureFramesUsed(result.framesUsed),
                style: theme.textTheme.bodySmall),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Card(
          child: Column(
            children: [
              for (final m in result.metrics)
                MetricTile(
                  metric: m,
                  change: previous?[m.metric] == null
                      ? null
                      : m.degrees - previous![m.metric]!.degrees,
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(l10n.postureDisclaimer, style: theme.textTheme.bodySmall),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: saved ? null : onSave,
                icon: Icon(saved ? Icons.check : Icons.save_outlined),
                label: Text(saved ? l10n.postureSavedShort : l10n.actionSave),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onRetake,
                icon: const Icon(Icons.replay),
                label: Text(l10n.postureRetake),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        if (recs.isNotEmpty) ...[
          Text(l10n.postureSuggestions, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          for (final r in recs) RecommendationCard(rec: r),
          Text(l10n.exerciseSafetyNote, style: theme.textTheme.bodySmall),
        ] else if (result.confidence == Confidence.low)
          Text(l10n.postureLowConfidenceNote),
      ],
    );
  }
}

class MetricTile extends StatelessWidget {
  const MetricTile({super.key, required this.metric, this.change});

  final MetricResult metric;

  /// Degrees compared with an earlier check, if any.
  final double? change;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final m = metric;
    return ListTile(
      leading: Icon(Icons.circle, size: 12, color: bandColor(scheme, m.band)),
      title: Text(l10n.postureMetricName(m.metric)),
      subtitle: Text([
        l10n.bandLabel(m.band),
        l10n.directionLabel(m.metric, m.direction),
        l10n.confidenceLabel(m.confidence),
        if (change != null) l10n.postureChange(
            '${change! > 0 ? '+' : ''}${change!.toStringAsFixed(1)}°'),
      ].join(' · ')),
      trailing: Text(l10n.valueDegrees(m.degrees.toStringAsFixed(1)),
          style: Theme.of(context).textTheme.titleMedium),
    );
  }
}

class RecommendationCard extends StatelessWidget {
  const RecommendationCard({super.key, required this.rec});

  final PostureRecommendation rec;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final e = rec.exercise;
    String reason(RecommendationReason r) => switch (r) {
          ObservedReason(:final metric) => l10n.whyObserved(
              l10n.postureMetricName(metric.metric),
              metric.degrees.toStringAsFixed(1),
              l10n.bandLabel(metric.band).toLowerCase()),
          RepeatedReason() => l10n.whyRepeated,
          GoalReason() => l10n.whyGoal,
          MaintenanceReason() => l10n.whyMaintenance,
        };

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ExerciseContent.pick(e.name, lang),
                style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(ExerciseContent.pick(e.summary, lang)),
            const SizedBox(height: AppSpacing.sm),
            for (final (i, step) in ExerciseContent.pickList(e.steps, lang).indexed)
              Text('${i + 1}. $step'),
            const SizedBox(height: AppSpacing.xs),
            Text(ExerciseContent.pick(e.dose, lang),
                style: theme.textTheme.labelLarge),
            const SizedBox(height: AppSpacing.md),
            Text(l10n.whyThis, style: theme.textTheme.labelLarge),
            for (final r in rec.reasons) Text('• ${reason(r)}'),
            if (rec.alternative != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(l10n.alternativeLabel(
                  ExerciseContent.pick(rec.alternative!.name, lang))),
            ],
            const SizedBox(height: AppSpacing.sm),
            Text(ExerciseContent.pick(e.safety, lang),
                style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
