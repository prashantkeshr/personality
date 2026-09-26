import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/logging/app_logger.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/health.dart';
import '../../../domain/services/health_stats.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/async_view.dart';
import '../../../shared/widgets/empty_state.dart';
import '../health_providers.dart';
import '../widgets/add_record_sheet.dart' show confirmDelete;
import '../widgets/health_widgets.dart';

/// Meals (spec §14). Calorie counting is optional and never required.
class MealsScreen extends ConsumerWidget {
  const MealsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final format = HealthFormat.of(
        context, ref.watch(settingsControllerProvider).unitSystem);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.featureMeals)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          showDragHandle: true,
          builder: (_) => const _AddMealSheet(),
        ),
        icon: const Icon(Icons.add),
        label: Text(l10n.mealAdd),
      ),
      body: AsyncView(
        value: ref.watch(mealsProvider),
        data: (meals) {
          if (meals.isEmpty) {
            return Center(
              child: EmptyState(
                icon: Icons.restaurant_outlined,
                title: l10n.featureMeals,
                message: l10n.mealsEmpty,
              ),
            );
          }
          final byDay = <int, List<MealEntry>>{};
          for (final m in meals) {
            byDay.putIfAbsent(Days.key(m.eatenAt), () => []).add(m);
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 96),
            children: [
              for (final entry in byDay.entries) ...[
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.lg),
                  child: Text(format.day(entry.value.first.eatenAt),
                      style: Theme.of(context).textTheme.labelLarge),
                ),
                for (final m in entry.value)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(m.food),
                    subtitle: Text([
                      m.type == MealType.custom && m.customName != null
                          ? m.customName!
                          : mealTypeLabel(l10n, m.type),
                      format.time(m.eatenAt),
                      ?m.quantity,
                      if (m.calories != null)
                        l10n.valueKcal(m.calories!.round()),
                    ].join(' · ')),
                    trailing: IconButton(
                      tooltip: l10n.actionDelete,
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () async {
                        if (await confirmDelete(context)) {
                          await ref.read(mealRepositoryProvider).delete(m.id);
                        }
                      },
                    ),
                  ),
              ],
            ],
          );
        },
      ),
    );
  }
}

/// Suggests the meal type from the time of day; the user can change it.
MealType suggestMealType(DateTime t) => switch (t.hour) {
      >= 5 && < 11 => MealType.breakfast,
      >= 11 && < 15 => MealType.lunch,
      >= 18 && < 23 => MealType.dinner,
      _ => MealType.snack,
    };

class _AddMealSheet extends ConsumerStatefulWidget {
  const _AddMealSheet();

  @override
  ConsumerState<_AddMealSheet> createState() => _AddMealSheetState();
}

class _AddMealSheetState extends ConsumerState<_AddMealSheet> {
  final _form = GlobalKey<FormState>();
  final _food = TextEditingController();
  final _quantity = TextEditingController();
  final _calories = TextEditingController();
  final _customName = TextEditingController();
  late DateTime _eatenAt = ref.read(clockProvider)();
  late MealType _type = suggestMealType(_eatenAt);
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [_food, _quantity, _calories, _customName]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final error = AppLocalizations.of(context).recordSaveError;
    try {
      await ref.read(mealRepositoryProvider).add(
            type: _type,
            customName: _customName.text,
            food: _food.text,
            quantity: _quantity.text,
            calories: parsePositive(_calories.text),
            eatenAt: _eatenAt,
          );
      navigator.pop();
    } catch (e, st) {
      AppLogger.error('meal.add', e, st);
      messenger.showSnackBar(SnackBar(content: Text(error)));
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final format = HealthFormat.of(
        context, ref.watch(settingsControllerProvider).unitSystem);
    return Padding(
      padding: EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl,
          MediaQuery.viewInsetsOf(context).bottom + AppSpacing.xl),
      child: Form(
        key: _form,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.mealAdd, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.lg),
              DropdownButtonFormField<MealType>(
                initialValue: _type,
                decoration: InputDecoration(labelText: l10n.mealType),
                items: [
                  for (final t in MealType.values)
                    DropdownMenuItem(
                        value: t, child: Text(mealTypeLabel(l10n, t))),
                ],
                onChanged: (t) => setState(() => _type = t!),
              ),
              if (_type == MealType.custom) ...[
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _customName,
                  decoration: InputDecoration(labelText: l10n.mealCustomName),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                key: const Key('meal-food'),
                controller: _food,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(labelText: l10n.mealFood),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? l10n.validationRequired
                    : null,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _quantity,
                decoration: InputDecoration(labelText: l10n.mealQuantity),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _calories,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.mealCalories,
                  helperText: l10n.mealCaloriesHelp,
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.schedule),
                title: Text(l10n.fieldTime),
                subtitle: Text(
                    '${format.day(_eatenAt)} · ${format.time(_eatenAt)}'),
                onTap: () async {
                  final t = await pickDateTime(context, _eatenAt);
                  if (t != null) setState(() => _eatenAt = t);
                },
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
