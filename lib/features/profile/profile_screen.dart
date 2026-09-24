import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/logging/app_logger.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/body.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/format/body_format.dart';
import '../../shared/widgets/async_view.dart';
import '../health/body_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final profile = ref.watch(profileProvider);
    final goals = ref.watch(goalsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
      body: AsyncView(
        value: profile,
        data: (p) => AsyncView(
          value: goals,
          data: (g) => _ProfileForm(initial: p, initialGoals: g),
        ),
      ),
    );
  }
}

class _ProfileForm extends ConsumerStatefulWidget {
  const _ProfileForm({required this.initial, required this.initialGoals});

  final Profile initial;
  final Set<GoalType> initialGoals;

  @override
  ConsumerState<_ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends ConsumerState<_ProfileForm> {
  late final _name = TextEditingController(text: widget.initial.displayName);
  late AgeRange? _age = widget.initial.ageRange;
  late ActivityLevel? _activity = widget.initial.activityLevel;
  late final Set<GoalType> _goals = {...widget.initialGoals};
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final repo = ref.read(profileRepositoryProvider);
    try {
      // Re-read so fields edited elsewhere (primary height, weight goal)
      // are preserved.
      final current = await repo.load();
      await repo.save(current.copyWith(
        displayName: () => _name.text,
        ageRange: () => _age,
        activityLevel: () => _activity,
      ));
      await repo.setGoals(_goals);
      messenger.showSnackBar(SnackBar(content: Text(l10n.profileSaved)));
    } catch (e, st) {
      AppLogger.error('profile.save', e, st);
      messenger.showSnackBar(SnackBar(content: Text(l10n.recordSaveError)));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(l10n.profileIntro,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        const SizedBox(height: AppSpacing.xl),
        TextField(
          controller: _name,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(labelText: l10n.profileName),
        ),
        const SizedBox(height: AppSpacing.lg),
        DropdownButtonFormField<AgeRange?>(
          initialValue: _age,
          decoration: InputDecoration(labelText: l10n.profileAgeRange),
          items: [
            DropdownMenuItem(value: null, child: Text(l10n.notSpecified)),
            for (final a in AgeRange.values)
              DropdownMenuItem(value: a, child: Text(l10n.ageRangeLabel(a))),
          ],
          onChanged: (a) => setState(() => _age = a),
        ),
        const SizedBox(height: AppSpacing.lg),
        DropdownButtonFormField<ActivityLevel?>(
          initialValue: _activity,
          decoration: InputDecoration(labelText: l10n.profileActivityLevel),
          items: [
            DropdownMenuItem(value: null, child: Text(l10n.notSpecified)),
            for (final a in ActivityLevel.values)
              DropdownMenuItem(value: a, child: Text(l10n.activityLabel(a))),
          ],
          onChanged: (a) => setState(() => _activity = a),
        ),
        const SizedBox(height: AppSpacing.xl),
        Semantics(
          header: true,
          child: Text(l10n.profileGoals, style: theme.textTheme.labelLarge),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final g in GoalType.values)
              FilterChip(
                label: Text(l10n.goalLabel(g)),
                selected: _goals.contains(g),
                onSelected: (on) => setState(
                    () => on ? _goals.add(g) : _goals.remove(g)),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: Text(l10n.actionSave),
        ),
      ],
    );
  }
}
