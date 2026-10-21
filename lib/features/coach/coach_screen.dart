import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/features/feature_registry.dart';
import '../../core/logging/app_logger.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/visual/hair_art.dart';
import '../../shared/visual/outfit_silhouette.dart' show hexColor;
import '../../shared/visual/style_art.dart';
import '../../shared/widgets/feature_labels.dart';
import '../content/content_providers.dart';
import '../exercise/figure/exercise_figure.dart';
import 'coach_brain.dart';
import 'coach_knowledge.dart';
import 'coach_model.dart';

/// Download state of the coach's model.
class CoachDownload {
  const CoachDownload({this.installed = false, this.progress, this.error});
  final bool installed;

  /// 0–1 while downloading.
  final double? progress;
  final CoachModelError? error;
}

class CoachDownloadController extends Notifier<CoachDownload> {
  Completer<void>? _cancel;

  @override
  CoachDownload build() {
    final store = ref.watch(coachModelStoreProvider).value;
    return CoachDownload(installed: store?.installed ?? false);
  }

  Future<void> start() async {
    if (state.progress != null) return;
    final store = await ref.read(coachModelStoreProvider.future);
    _cancel = Completer<void>();
    state = const CoachDownload(progress: 0);
    try {
      await store.download(
        cancel: _cancel!.future,
        onProgress: (p) {
          // Repaint at most every 0.5 %.
          if ((p - (state.progress ?? 0)) >= 0.005 || p >= 1) {
            state = CoachDownload(progress: p);
          }
        },
      );
      state = const CoachDownload(installed: true);
    } on CoachModelException catch (e) {
      state = CoachDownload(error: _cancel!.isCompleted ? null : e.error);
    } catch (e, st) {
      AppLogger.error('coach.download', e, st);
      state = const CoachDownload(error: CoachModelError.download);
    }
  }

  void cancel() {
    if (_cancel != null && !_cancel!.isCompleted) _cancel!.complete();
  }

  Future<void> remove() async {
    await ref.read(coachRuntimeProvider).dispose();
    await (await ref.read(coachModelStoreProvider.future)).remove();
    state = const CoachDownload();
  }
}

final coachDownloadProvider =
    NotifierProvider<CoachDownloadController, CoachDownload>(
      CoachDownloadController.new,
    );

String _sizeMb(int bytes) => '${(bytes / (1 << 20)).round()} MB';

/// "Ask your coach": answers from the app's own knowledge and the user's
/// data, with pictures and links. Runs offline; with the optional model it
/// writes the answer, without it it shows the best matches.
class CoachScreen extends ConsumerStatefulWidget {
  const CoachScreen({super.key, this.initial});
  final String? initial;

  @override
  ConsumerState<CoachScreen> createState() => _CoachScreenState();
}

class _CoachScreenState extends ConsumerState<CoachScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.initial case final q? when q.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _send(q));
    }
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send([String? text]) {
    final q = (text ?? _input.text).trim();
    if (q.isEmpty) return;
    _input.clear();
    ref
        .read(coachProvider.notifier)
        .ask(q, Localizations.localeOf(context).languageCode);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent + 400,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _download() async {
    final l = AppLocalizations.of(context);
    final net = await ref.read(networkStateProvider)();
    if (!mounted) return;
    if (!net.online) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.contentOffline)));
      return;
    }
    if (!net.unmetered) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text(l.contentMobileTitle),
          content: Text(l.contentMobileBody(l.coachTitle, _sizeMb(CoachModelInfo.size))),
          actions: [
            TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l.contentMobileWait)),
            FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(l.contentMobileUse)),
          ],
        ),
      );
      if (ok != true) return;
    }
    await ref.read(coachDownloadProvider.notifier).start();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final messages = ref.watch(coachProvider);
    final busy = messages.isNotEmpty && messages.last.streaming;
    final capable = ref.watch(coachDeviceCapableProvider);
    final download = ref.watch(coachDownloadProvider);
    ref.listen(coachProvider, (_, _) {
      if (_scroll.hasClients) {
        _scroll.jumpTo(_scroll.position.maxScrollExtent);
      }
    });

    final prompts = [
      l.coachPromptFocus,
      l.coachPromptPosture,
      l.coachPromptDinner,
      l.coachPromptHair,
      l.coachPromptSleep,
      l.coachPromptYoga,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l.coachTitle),
        actions: [
          if (messages.isNotEmpty)
            IconButton(
              tooltip: l.coachClear,
              onPressed: () => ref.read(coachProvider.notifier).clear(),
              icon: const Icon(Icons.delete_sweep_outlined),
            ),
          if (download.installed)
            PopupMenuButton<String>(
              onSelected: (_) => ref.read(coachDownloadProvider.notifier).remove(),
              itemBuilder: (_) => [
                PopupMenuItem(value: 'remove', child: Text(l.coachRemoveModel)),
              ],
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.lg),
              children: [
                _ModelCard(
                  capable: capable,
                  download: download,
                  onDownload: _download,
                  onCancel: () => ref.read(coachDownloadProvider.notifier).cancel(),
                ),
                if (messages.isEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(l.coachIntro, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final (i, p) in prompts.indexed)
                        ActionChip(
                          key: Key('coach-prompt-$i'),
                          avatar: const Icon(Icons.auto_awesome, size: 16),
                          label: Text(p),
                          onPressed: () => _send(p),
                        ),
                    ],
                  ),
                ],
                for (final m in messages) _Bubble(message: m),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l.coachNote,
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.xs, AppSpacing.md, AppSpacing.sm),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      key: const Key('coach-input'),
                      controller: _input,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: InputDecoration(
                        hintText: l.coachHint,
                        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  busy
                      ? IconButton.filledTonal(
                          key: const Key('coach-stop'),
                          tooltip: l.coachStop,
                          onPressed: () => ref.read(coachProvider.notifier).stop(),
                          icon: const Icon(Icons.stop),
                        )
                      : IconButton.filled(
                          key: const Key('coach-send'),
                          tooltip: l.coachSend,
                          onPressed: _send,
                          icon: const Icon(Icons.send),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModelCard extends StatelessWidget {
  const _ModelCard({
    required this.capable,
    required this.download,
    required this.onDownload,
    required this.onCancel,
  });

  final bool capable;
  final CoachDownload download;
  final VoidCallback onDownload;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final (icon, title, body) = !capable
        ? (Icons.travel_explore, l.coachSearchMode, l.coachSearchModeInfo)
        : download.installed
        ? (Icons.offline_bolt_outlined, l.coachReady, l.coachReadyInfo)
        : (Icons.download_for_offline_outlined, l.coachGetModel,
            l.coachGetModelInfo(_sizeMb(CoachModelInfo.size)));
    return Card(
      key: const Key('coach-model'),
      color: download.installed ? scheme.secondaryContainer : null,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(icon, color: scheme.primary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(title, style: theme.textTheme.titleSmall)),
            ]),
            const SizedBox(height: AppSpacing.xs),
            Text(body, style: theme.textTheme.bodySmall),
            if (capable && !download.installed) ...[
              const SizedBox(height: AppSpacing.sm),
              if (download.progress case final p?)
                Row(children: [
                  Expanded(child: LinearProgressIndicator(value: p)),
                  const SizedBox(width: AppSpacing.sm),
                  Text('${(p * 100).round()}%'),
                  TextButton(onPressed: onCancel, child: Text(l.actionCancel)),
                ])
              else ...[
                if (download.error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: Text(
                      download.error == CoachModelError.storage ? l.coachNoSpace : l.contentFailed,
                      style: TextStyle(color: scheme.error),
                    ),
                  ),
                FilledButton.icon(
                  key: const Key('coach-download'),
                  onPressed: onDownload,
                  icon: const Icon(Icons.download),
                  label: Text(l.coachDownload(_sizeMb(CoachModelInfo.size))),
                ),
              ],
              const SizedBox(height: AppSpacing.xs),
              Text(CoachModelInfo.licence, style: theme.textTheme.labelSmall),
            ],
          ],
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message});
  final CoachMessage message;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final m = message;
    final bubble = Container(
      margin: const EdgeInsets.only(top: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      constraints: const BoxConstraints(maxWidth: 520),
      decoration: BoxDecoration(
        color: m.fromUser ? scheme.primary : scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(18),
      ),
      child: m.text.isEmpty && m.streaming
          ? const SizedBox(width: 40, height: 18, child: LinearProgressIndicator())
          : Text(
              m.text.isEmpty ? l.coachNothing : m.text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: m.fromUser ? scheme.onPrimary : scheme.onSurface,
              ),
            ),
    );
    if (m.fromUser) {
      return Align(alignment: AlignmentDirectional.centerEnd, child: bubble);
    }
    return Column(
      key: const Key('coach-answer'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (m.offline)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: Text(l.coachFromLibrary, style: theme.textTheme.labelSmall),
          ),
        Align(alignment: AlignmentDirectional.centerStart, child: bubble),
        if (m.cards.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 196,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: m.cards.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (_, i) => CoachCard(item: m.cards[i]),
            ),
          ),
        ],
      ],
    );
  }
}

/// A suggestion: picture, title, what it is, and a button to open it.
class CoachCard extends StatelessWidget {
  const CoachCard({super.key, required this.item});
  final KnowledgeItem item;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return SizedBox(
      width: 168,
      child: Card(
        key: Key('coach-card-${item.id}'),
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push(item.route),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 96, width: double.infinity, child: CoachVisualView(visual: item.visual)),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
                child: Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 6),
                child: Row(children: [
                  Expanded(
                    child: Text(
                      coachKindLabel(l, item.kind),
                      style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.primary),
                    ),
                  ),
                  Text(l.coachOpen, style: theme.textTheme.labelMedium),
                  const Icon(Icons.chevron_right, size: 16),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String coachKindLabel(AppLocalizations l, KnowledgeKind k) => switch (k) {
  KnowledgeKind.exercise => l.featureExercise,
  KnowledgeKind.program => l.coachKindWorkout,
  KnowledgeKind.skill => l.skillsTitle,
  KnowledgeKind.answer => l.qaTitle,
  KnowledgeKind.makeup => l.makeupTitle,
  KnowledgeKind.trend => l.trendsTitle,
  KnowledgeKind.hairstyle => l.styleHair,
  KnowledgeKind.beard => l.styleBeard,
  KnowledgeKind.glasses => l.styleGlasses,
  KnowledgeKind.meal => l.featureMeals,
  KnowledgeKind.section => l.coachKindSection,
};

class CoachVisualView extends StatelessWidget {
  const CoachVisualView({super.key, required this.visual});
  final CoachVisual visual;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    Widget tinted(Widget child) => ColoredBox(
      color: scheme.primaryContainer,
      child: Padding(padding: const EdgeInsets.all(8), child: child),
    );
    switch (visual) {
      case PhotoVisual(:final asset):
        return Image.asset(asset, fit: BoxFit.cover);
      case FigureVisual(:final motionId):
        return tinted(ExerciseFigure(motionId: motionId, still: true));
      case HairVisual(:final shape):
        final s = HairShape.fromName(shape);
        return s == null ? tinted(const Icon(Icons.content_cut)) : ColoredBox(color: scheme.primaryContainer, child: HairArt(shape: s));
      case GlassesVisual(:final itemId):
        final g = glassesStyleFor(itemId);
        return tinted(g == null
            ? const Icon(Icons.visibility_outlined)
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                child: GlassesArt(style: g, color: scheme.onPrimaryContainer),
              ));
      case ColourVisual(:final hex):
        return ColoredBox(color: hexColor(hex));
      case SectionVisual(:final feature):
        final f = feature == null ? null : AppFeature.values.asNameMap()[feature];
        final image = f == null ? null : featureImage(f);
        if (image != null) return Image.asset(image, fit: BoxFit.cover);
        return tinted(Icon(f == null ? Icons.auto_awesome : featureIcon(f), size: 40, color: scheme.onPrimaryContainer));
    }
  }
}
