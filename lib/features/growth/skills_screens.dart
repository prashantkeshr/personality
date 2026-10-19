import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'practice_planner.dart';
import '../today/now_providers.dart';
import '../../app/router.dart';
import '../../core/theme/app_theme.dart';
import '../../data/content/content_packs.dart' show PackInfo;
import '../../domain/entities/discipline.dart';
import '../../domain/entities/exercise_library.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/async_view.dart';
import '../content/content_providers.dart';
import '../exercise/figure/exercise_figure.dart';
import '../exercise/figure/exercise_visual.dart';
import '../health/widgets/health_widgets.dart';
import 'growth_providers.dart';

String _t(Map<String, String> m, String lang) => PackInfo.pick(m, lang);

/// Each discipline gets its own colours, built from its hue.
ThemeData disciplineTheme(BuildContext context, Discipline d) {
  final base = Theme.of(context);
  final seed = HSLColor.fromAHSL(1, d.hue, 0.6, 0.42).toColor();
  return base.copyWith(colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: base.brightness));
}

/// A search field that opens the global search.
class GrowthSearchBar extends StatelessWidget {
  const GrowthSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SearchBar(
      key: const Key('growth-search'),
      hintText: l.growthSearchHint,
      leading: const Icon(Icons.search),
      elevation: const WidgetStatePropertyAll(0),
      onTap: () => context.push(AppRoutes.search),
      onChanged: (_) {},
      readOnly: true,
    );
  }
}

class DisciplineCard extends ConsumerWidget {
  const DisciplineCard({super.key, required this.discipline, this.width = 168});
  final Discipline discipline;
  final double width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final count = ref.watch(techniquesByDisciplineProvider)[discipline.id]?.length ?? 0;
    return Theme(
      data: disciplineTheme(context, discipline),
      child: Builder(builder: (context) {
        final theme = Theme.of(context);
        final scheme = theme.colorScheme;
        return SizedBox(
          width: width,
          height: 196,
          child: Card(
            margin: EdgeInsets.zero,
            color: scheme.primaryContainer,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              key: Key('discipline-${discipline.id}'),
              onTap: () => context.push('${AppRoutes.skills}/${discipline.id}'),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: Center(child: ExerciseFigure(motionId: discipline.motion, still: true))),
                  const SizedBox(height: AppSpacing.sm),
                  Text(_t(discipline.name, lang),
                      style: theme.textTheme.titleSmall
                          ?.copyWith(color: scheme.onPrimaryContainer, fontWeight: FontWeight.w700),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  Text(_t(discipline.region, lang),
                      style: theme.textTheme.bodySmall?.copyWith(color: scheme.onPrimaryContainer),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: AppSpacing.xs),
                  Text(count == 0 ? l.skillsGetPackShort : l.skillsTechniques(count),
                      style: theme.textTheme.labelSmall?.copyWith(color: scheme.primary)),
                ]),
              ),
            ),
          ),
        );
      }),
    );
  }
}

/// All martial arts and skills, Indian first.
class SkillsScreen extends ConsumerWidget {
  const SkillsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.skillsTitle)),
      body: AsyncView(
        value: ref.watch(disciplinesProvider),
        data: (all) {
          Widget grid(List<Discipline> ds) => LayoutBuilder(builder: (context, c) {
                final cols = c.maxWidth > 600 ? 4 : 2;
                final w = (c.maxWidth - AppSpacing.sm * (cols - 1)) / cols;
                return Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: [
                  for (final d in ds) DisciplineCard(discipline: d, width: w),
                ]);
              });
          return ListView(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 96),
            children: [
              const GrowthSearchBar(),
              const SizedBox(height: AppSpacing.md),
              Text(l.skillsIntro, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: AppSpacing.lg),
              Text(l.skillsMindBody, style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              grid(all.where((d) => d.mindBody).toList()),
              const SizedBox(height: AppSpacing.lg),
              Text(l.skillsIndian, style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              grid(all.where((d) => d.indian).toList()),
              const SizedBox(height: AppSpacing.lg),
              Text(l.skillsWorld, style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              grid(all.where((d) => !d.indian && !d.mindBody).toList()),
              const SizedBox(height: AppSpacing.lg),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(Icons.shield_outlined, size: 18, color: theme.colorScheme.primary),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: Text(l.skillsSafety, style: theme.textTheme.bodySmall)),
              ]),
            ],
          );
        },
      ),
    );
  }
}

String kindLabel(AppLocalizations l, String? kind) => switch (kind) {
      'stance' => l.kindStance,
      'technique' => l.kindTechnique,
      'drill' => l.kindDrill,
      'conditioning' => l.kindConditioning,
      _ => l.kindTechnique,
    };

/// One discipline: about, techniques by kind, tips and tricks, drills.
class DisciplineScreen extends ConsumerStatefulWidget {
  const DisciplineScreen({super.key, required this.id});
  final String id;

  @override
  ConsumerState<DisciplineScreen> createState() => _DisciplineScreenState();
}

class _DisciplineScreenState extends ConsumerState<DisciplineScreen> {
  String? _kind;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final all = ref.watch(disciplinesProvider).value;
    final d = all?.where((x) => x.id == widget.id).firstOrNull;
    if (d == null) {
      return Scaffold(
          appBar: AppBar(),
          body: Center(child: all == null ? const CircularProgressIndicator() : Text(l.loadErrorBody)));
    }
    final techniques = ref.watch(techniquesByDisciplineProvider)[d.id] ?? const <LibraryExercise>[];
    final programs = (ref.watch(programCatalogProvider).value ?? const <WorkoutProgram>[])
        .where((p) => p.discipline == d.id)
        .toList();
    final installed = (ref.watch(installedPacksProvider).value ?? const []).any((p) => p.info.id == d.pack);
    final kinds = [
      for (final k in ['stance', 'technique', 'drill', 'conditioning'])
        if (techniques.any((t) => t.kind == k)) k
    ];
    final shown = _kind == null ? techniques : techniques.where((t) => t.kind == _kind).toList();

    return Theme(
      data: disciplineTheme(context, d),
      child: Builder(builder: (context) {
        final theme = Theme.of(context);
        final scheme = theme.colorScheme;
        Widget heading(String s) => Padding(
              padding: const EdgeInsets.only(top: AppSpacing.lg, bottom: AppSpacing.sm),
              child: Text(s, style: theme.textTheme.titleMedium),
            );
        return Scaffold(
          appBar: AppBar(title: Text(_t(d.name, lang))),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, 96),
            children: [
              Card(
                color: scheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    SizedBox(height: 180, child: ExerciseFigure(motionId: d.motion)),
                    const SizedBox(height: AppSpacing.sm),
                    Text(_t(d.region, lang),
                        style: theme.textTheme.labelLarge?.copyWith(color: scheme.onPrimaryContainer)),
                    const SizedBox(height: AppSpacing.xs),
                    Text(_t(d.about, lang),
                        style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onPrimaryContainer)),
                    const SizedBox(height: AppSpacing.sm),
                    Text('${l.skillsTrains}: ${_t(d.trains, lang)}',
                        style: theme.textTheme.bodySmall?.copyWith(color: scheme.onPrimaryContainer)),
                  ]),
                ),
              ),
              Card(
                child: SwitchListTile(
                  key: const Key('skill-practise'),
                  secondary: const Icon(Icons.event_repeat),
                  title: Text(l.skillsPractiseRegularly),
                  subtitle: Text(l.skillsPractiseInfo),
                  value: (ref.watch(nowStateProvider).value?.skills ?? const []).contains(d.id),
                  onChanged: (on) => ref.read(nowActionsProvider).setSkill(d.id, on),
                ),
              ),
              Card(
                child: ListTile(
                  key: const Key('skill-add-to-day'),
                  leading: const Icon(Icons.event_available),
                  title: Text(l.practiceAddButton),
                  subtitle: Text(l.practiceAddInfo),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => showAddToDaySheet(context, skillId: d.id, skillName: _t(d.name, lang)),
                ),
              ),
              Card(
                color: scheme.tertiaryContainer,
                child: ListTile(
                  leading: Icon(Icons.shield_outlined, color: scheme.onTertiaryContainer),
                  title: Text(_t(d.safety, lang),
                      style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onTertiaryContainer)),
                ),
              ),
              if (!installed && techniques.isEmpty)
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.download_for_offline_outlined),
                    title: Text(l.skillsGetPack),
                    subtitle: Text(l.skillsGetPackInfo),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push(AppRoutes.content),
                  ),
                ),
              if (techniques.isNotEmpty) ...[
                heading(l.skillsTechniquesTitle),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
                      child: ChoiceChip(
                          label: Text(l.filterAll),
                          selected: _kind == null,
                          onSelected: (_) => setState(() => _kind = null)),
                    ),
                    for (final k in kinds)
                      Padding(
                        padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
                        child: ChoiceChip(
                            label: Text(kindLabel(l, k)),
                            selected: _kind == k,
                            onSelected: (_) => setState(() => _kind = _kind == k ? null : k)),
                      ),
                  ]),
                ),
                const SizedBox(height: AppSpacing.sm),
                for (final t in shown)
                  Card(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: ListTile(
                      leading: SizedBox.square(dimension: 52, child: ExerciseVisual(exercise: t, still: true)),
                      title: Text(LibraryExercise.pick(t.name, lang)),
                      subtitle: Text([
                        kindLabel(l, t.kind),
                        if (t.dose.isNotEmpty) LibraryExercise.pick(t.dose, lang),
                      ].join(' · ')),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push('${AppRoutes.exerciseLibrary}/${Uri.encodeComponent(t.id)}'),
                    ),
                  ),
              ],
              if (programs.isNotEmpty) ...[
                heading(l.skillsWorkouts),
                for (final p in programs)
                  Card(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: ListTile(
                      leading: Icon(Icons.play_circle_outline, color: scheme.primary),
                      title: Text(LibraryExercise.pick(p.title, lang)),
                      subtitle: Text(l.workoutMinutes(p.minutes)),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push('${AppRoutes.programs}/${p.id}'),
                    ),
                  ),
              ],
              heading(l.skillsTips),
              for (final tip in d.tips)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Icon(Icons.lightbulb_outline, size: 18, color: scheme.primary),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: Text(_t(tip, lang))),
                  ]),
                ),
            ],
          ),
        );
      }),
    );
  }
}

/// One search for exercises, techniques, tips, workouts and skills.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key, this.initial = ''});
  final String initial;

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final _controller = TextEditingController(text: widget.initial);
  late String _q = widget.initial.trim().toLowerCase();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _has(Map<String, String> m) => m.values.any((v) => v.toLowerCase().contains(_q));

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final theme = Theme.of(context);
    final exercises = ref.watch(exerciseCatalogProvider).value ?? const <LibraryExercise>[];
    final programs = ref.watch(programCatalogProvider).value ?? const <WorkoutProgram>[];
    final disciplines = ref.watch(disciplinesProvider).value ?? const <Discipline>[];
    final names = {for (final d in disciplines) d.id: d};

    final skillHits = _q.isEmpty
        ? const <Discipline>[]
        : disciplines.where((d) => _has(d.name) || _has(d.region) || _has(d.about)).toList();
    final exerciseHits = _q.isEmpty
        ? const <LibraryExercise>[]
        : exercises
            .where((e) =>
                _has(e.name) ||
                e.muscles.any((m) => m.contains(_q)) ||
                (e.equipment?.contains(_q) ?? false) ||
                (e.discipline != null && names[e.discipline] != null && _has(names[e.discipline]!.name)))
            .toList();
    final tipHits = _q.isEmpty
        ? const <(Discipline, Map<String, String>)>[]
        : [
            for (final d in disciplines)
              for (final t in d.tips)
                if (_has(t) || _has(d.name)) (d, t)
          ];
    final programHits =
        _q.isEmpty ? const <WorkoutProgram>[] : programs.where((p) => _has(p.title) || _has(p.summary)).toList();
    final total = skillHits.length + exerciseHits.length + tipHits.length + programHits.length;
    const maxExercises = 60;

    Widget heading(String s) => Padding(
          padding: const EdgeInsets.only(top: AppSpacing.lg, bottom: AppSpacing.sm),
          child: Text(s, style: theme.textTheme.titleMedium),
        );

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          key: const Key('search-field'),
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(hintText: l.growthSearchHint, border: InputBorder.none),
          onChanged: (v) => setState(() => _q = v.trim().toLowerCase()),
        ),
        actions: [
          if (_q.isNotEmpty)
            IconButton(
              tooltip: l.searchClear,
              icon: const Icon(Icons.close),
              onPressed: () => setState(() {
                _controller.clear();
                _q = '';
              }),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, 96),
        children: [
          if (_q.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Text(l.searchEmpty, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
            )
          else if (total == 0)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Text(l.searchNoResults(_controller.text.trim()),
                  textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
            ),
          if (skillHits.isNotEmpty) ...[
            heading(l.searchSkills),
            SizedBox(
              height: 196,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: skillHits.length,
                separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
                itemBuilder: (_, i) => DisciplineCard(discipline: skillHits[i]),
              ),
            ),
          ],
          if (exerciseHits.isNotEmpty) ...[
            heading('${l.searchExercises} (${exerciseHits.length})'),
            for (final e in exerciseHits.take(maxExercises))
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: SizedBox.square(dimension: 44, child: ExerciseVisual(exercise: e, still: true)),
                title: Text(LibraryExercise.pick(e.name, lang)),
                subtitle: Text([
                  if (e.discipline != null && names[e.discipline] != null)
                    _t(names[e.discipline]!.name, lang)
                  else
                    exerciseCategoryLabel(l, e.category),
                  if (e.muscles.isNotEmpty) e.muscles.first,
                ].join(' · ')),
                onTap: () => context.push('${AppRoutes.exerciseLibrary}/${Uri.encodeComponent(e.id)}'),
              ),
            if (exerciseHits.length > maxExercises)
              Text(l.searchMore(exerciseHits.length - maxExercises), style: theme.textTheme.bodySmall),
          ],
          if (programHits.isNotEmpty) ...[
            heading(l.searchWorkouts),
            for (final p in programHits)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.play_circle_outline),
                title: Text(LibraryExercise.pick(p.title, lang)),
                subtitle: Text(l.workoutMinutes(p.minutes)),
                onTap: () => context.push('${AppRoutes.programs}/${p.id}'),
              ),
          ],
          if (tipHits.isNotEmpty) ...[
            heading(l.searchTips),
            for (final (d, t) in tipHits.take(30))
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.lightbulb_outline),
                title: Text(_t(t, lang)),
                subtitle: Text(_t(d.name, lang)),
                onTap: () => context.push('${AppRoutes.skills}/${d.id}'),
              ),
          ],
        ],
      ),
    );
  }
}
