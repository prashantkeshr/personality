import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/router.dart';
import '../../core/logging/app_logger.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/health.dart';
import '../../domain/entities/routine.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/async_view.dart';
import '../../shared/widgets/empty_state.dart';
import '../health/widgets/add_record_sheet.dart' show confirmDelete;
import 'reminder_sync_host.dart';
import 'routine_providers.dart';

/// Short weekday list ("Mon, Wed, Fri" or "Every day").
String describeDays(BuildContext context, Weekdays days) {
  final l10n = AppLocalizations.of(context);
  if (days.count == 7) return l10n.everyDay;
  final tag = Localizations.localeOf(context).toLanguageTag();
  return [
    for (var d = 1; d <= 7; d++)
      if (days.includes(d)) DateFormat.E(tag).format(DateTime(2024, 1, d)),
  ].join(', ');
}

Future<void> _guard(BuildContext context, Future<void> Function() action) async {
  final messenger = ScaffoldMessenger.of(context);
  final error = AppLocalizations.of(context).recordSaveError;
  try {
    await action();
  } catch (e, st) {
    AppLogger.error('routine.action', e, st);
    messenger.showSnackBar(SnackBar(content: Text(error)));
  }
}

class RoutinesScreen extends ConsumerWidget {
  const RoutinesScreen({super.key});

  Future<void> _create(BuildContext context, WidgetRef ref,
      {bool fromExample = false}) async {
    final l10n = AppLocalizations.of(context);
    final repo = ref.read(routineRepositoryProvider);
    await _guard(context, () async {
      final id = fromExample
          ? await repo.createFromTemplate(l10n.templateRoutineName, [
              for (final (minute, step, kind) in exampleRoutineSteps)
                (minute, templateStepTitle(l10n, step), kind),
            ])
          : await repo.createRoutine(l10n.newRoutineName, Weekdays.everyDay);
      if (context.mounted) context.push('${AppRoutes.routines}/$id');
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final items = ref.watch(routineItemsProvider).value ?? const [];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.featureRoutines),
        actions: [
          TextButton.icon(
            onPressed: () => context.push(AppRoutes.plan),
            icon: const Icon(Icons.today_outlined),
            label: Text(l10n.planTitle),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _create(context, ref),
        icon: const Icon(Icons.add),
        label: Text(l10n.routineNew),
      ),
      body: AsyncView(
        value: ref.watch(routinesProvider),
        data: (routines) {
          if (routines.isEmpty) {
            return Center(
              child: EmptyState(
                icon: Icons.schedule,
                title: l10n.featureRoutines,
                message: l10n.routinesEmpty,
                action: OutlinedButton(
                  onPressed: () => _create(context, ref, fromExample: true),
                  child: Text(l10n.routineFromExample),
                ),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 96),
            children: [
              for (final r in routines)
                Card(
                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: ListTile(
                    title: Text(r.name),
                    subtitle: Text(
                        '${describeDays(context, r.days)} · ${l10n.routineItemCount(items.where((i) => i.routineId == r.id).length)}'),
                    trailing: Switch(
                      value: r.active,
                      onChanged: (on) => _guard(
                          context,
                          () => ref
                              .read(routineRepositoryProvider)
                              .updateRoutine(r.id, active: on)),
                    ),
                    onTap: () => context.push('${AppRoutes.routines}/${r.id}'),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

enum _RoutineMenu { duplicate, delete }

enum _ItemMenu { edit, duplicate, delete }

class RoutineEditorScreen extends ConsumerWidget {
  const RoutineEditorScreen({super.key, required this.routineId});

  final String routineId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final routines = ref.watch(routinesProvider).value;
    final routine = routines?.where((r) => r.id == routineId).firstOrNull;
    final items = (ref.watch(routineItemsProvider).value ?? const [])
        .where((i) => i.routineId == routineId)
        .toList();
    final repo = ref.read(routineRepositoryProvider);

    if (routines == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (routine == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: EmptyState(
            icon: Icons.schedule,
            title: l10n.featureRoutines,
            message: l10n.routineNotFound,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(routine.name),
        actions: [
          IconButton(
            tooltip: l10n.actionEdit,
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              showDragHandle: true,
              builder: (_) => _RoutineDetailsSheet(routine: routine),
            ),
          ),
          PopupMenuButton<_RoutineMenu>(
            onSelected: (m) async {
              switch (m) {
                case _RoutineMenu.duplicate:
                  await _guard(context, () async {
                    final id = await repo.duplicateRoutine(
                        routine.id, l10n.routineCopyName(routine.name));
                    if (context.mounted) {
                      context.pushReplacement('${AppRoutes.routines}/$id');
                    }
                  });
                case _RoutineMenu.delete:
                  if (await confirmDelete(context)) {
                    await repo.deleteRoutine(routine.id);
                    if (context.mounted) context.pop();
                  }
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                  value: _RoutineMenu.duplicate,
                  child: Text(l10n.actionDuplicate)),
              PopupMenuItem(
                  value: _RoutineMenu.delete, child: Text(l10n.actionDelete)),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _editItem(context, routineId: routine.id),
        icon: const Icon(Icons.add),
        label: Text(l10n.routineAddItem),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 96),
        children: [
          Text(describeDays(context, routine.days),
              style: Theme.of(context).textTheme.bodyMedium),
          if (!routine.active)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Text(l10n.routinePaused,
                  style: Theme.of(context).textTheme.bodySmall),
            ),
          const SizedBox(height: AppSpacing.md),
          if (items.isEmpty) Text(l10n.routineNoItems),
          for (final item in items)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(routineKindIcon(item.kind)),
              title: Text(item.title),
              subtitle: Text(formatMinute(context, item.minuteOfDay)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item.reminder
                        ? Icons.notifications_active_outlined
                        : Icons.notifications_off_outlined,
                    semanticLabel:
                        item.reminder ? l10n.reminderOn : l10n.reminderOff,
                    size: 20,
                  ),
                  PopupMenuButton<_ItemMenu>(
                    onSelected: (m) async {
                      switch (m) {
                        case _ItemMenu.edit:
                          await _editItem(context,
                              routineId: routine.id, item: item);
                        case _ItemMenu.duplicate:
                          await _guard(
                              context,
                              () => repo.addItem(routine.id, item.minuteOfDay,
                                  item.title, item.kind,
                                  reminder: item.reminder));
                        case _ItemMenu.delete:
                          if (await confirmDelete(context)) {
                            await repo.deleteItem(item.id);
                          }
                      }
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                          value: _ItemMenu.edit, child: Text(l10n.actionEdit)),
                      PopupMenuItem(
                          value: _ItemMenu.duplicate,
                          child: Text(l10n.actionDuplicate)),
                      PopupMenuItem(
                          value: _ItemMenu.delete,
                          child: Text(l10n.actionDelete)),
                    ],
                  ),
                ],
              ),
              onTap: () =>
                  _editItem(context, routineId: routine.id, item: item),
            ),
        ],
      ),
    );
  }

  Future<void> _editItem(BuildContext context,
          {required String routineId, RoutineItem? item}) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        showDragHandle: true,
        builder: (_) => _ItemSheet(routineId: routineId, item: item),
      );
}

class _RoutineDetailsSheet extends ConsumerStatefulWidget {
  const _RoutineDetailsSheet({required this.routine});

  final Routine routine;

  @override
  ConsumerState<_RoutineDetailsSheet> createState() =>
      _RoutineDetailsSheetState();
}

class _RoutineDetailsSheetState extends ConsumerState<_RoutineDetailsSheet> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.routine.name);
  late Weekdays _days = widget.routine.days;
  bool _daysError = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tag = Localizations.localeOf(context).toLanguageTag();
    return Padding(
      padding: EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl,
          MediaQuery.viewInsetsOf(context).bottom + AppSpacing.xl),
      child: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              key: const Key('routine-name'),
              controller: _name,
              decoration: InputDecoration(labelText: l10n.routineName),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? l10n.validationRequired
                  : null,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.habitDays, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                for (var d = 1; d <= 7; d++)
                  FilterChip(
                    label: Text(DateFormat.E(tag).format(DateTime(2024, 1, d))),
                    selected: _days.includes(d),
                    onSelected: (_) => setState(() => _days = _days.toggle(d)),
                  ),
              ],
            ),
            if (_daysError)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text(l10n.habitDaysRequired,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error)),
              ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: () async {
                final ok = _form.currentState!.validate();
                setState(() => _daysError = _days.isEmpty);
                if (!ok || _days.isEmpty) return;
                final navigator = Navigator.of(context);
                await _guard(
                    context,
                    () => ref.read(routineRepositoryProvider).updateRoutine(
                        widget.routine.id,
                        name: _name.text,
                        days: _days));
                navigator.pop();
              },
              child: Text(l10n.actionSave),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemSheet extends ConsumerStatefulWidget {
  const _ItemSheet({required this.routineId, this.item});

  final String routineId;
  final RoutineItem? item;

  @override
  ConsumerState<_ItemSheet> createState() => _ItemSheetState();
}

class _ItemSheetState extends ConsumerState<_ItemSheet> {
  final _form = GlobalKey<FormState>();
  late final _title = TextEditingController(text: widget.item?.title);
  late int _minute = widget.item?.minuteOfDay ?? 9 * 60;
  late RoutineItemKind _kind = widget.item?.kind ?? RoutineItemKind.custom;
  late bool _reminder = widget.item?.reminder ?? true;
  bool _saving = false;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);
    final navigator = Navigator.of(context);
    final repo = ref.read(routineRepositoryProvider);
    await _guard(context, () async {
      if (widget.item == null) {
        await repo.addItem(widget.routineId, _minute, _title.text, _kind,
            reminder: _reminder);
      } else {
        await repo.updateItem(widget.item!.id,
            minute: _minute,
            title: _title.text,
            kind: _kind,
            reminder: _reminder);
      }
      navigator.pop();
    });
    if (mounted) setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl,
          MediaQuery.viewInsetsOf(context).bottom + AppSpacing.xl),
      child: Form(
        key: _form,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(widget.item == null ? l10n.routineAddItem : l10n.actionEdit,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.lg),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.schedule),
                title: Text(l10n.fieldTime),
                subtitle: Text(formatMinute(context, _minute)),
                onTap: () async {
                  final t = await showTimePicker(
                    context: context,
                    initialTime:
                        TimeOfDay(hour: _minute ~/ 60, minute: _minute % 60),
                  );
                  if (t != null) setState(() => _minute = t.hour * 60 + t.minute);
                },
              ),
              TextFormField(
                key: const Key('item-title'),
                controller: _title,
                autofocus: widget.item == null,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(labelText: l10n.routineItemTitle),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? l10n.validationRequired
                    : null,
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<RoutineItemKind>(
                initialValue: _kind,
                decoration: InputDecoration(labelText: l10n.routineItemKind),
                items: [
                  for (final k in RoutineItemKind.values)
                    DropdownMenuItem(
                      value: k,
                      child: Row(children: [
                        Icon(routineKindIcon(k), size: 18),
                        const SizedBox(width: AppSpacing.sm),
                        Text(routineKindLabel(l10n, k)),
                      ]),
                    ),
                ],
                onChanged: (k) => setState(() => _kind = k!),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.reminderOn),
                value: _reminder,
                onChanged: (v) => setState(() => _reminder = v),
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: Text(l10n.actionSave),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
