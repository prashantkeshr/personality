import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../permissions/app_permissions.dart';
import '../permissions/permission_widgets.dart';
import '../reminders/goal_reminders.dart';

/// Reminders to switch on when setup finishes (only if notifications are
/// allowed by then).
class StarterReminders extends ChangeNotifier {
  bool meals = true;
  bool postureCheck = true;

  void set({bool? meals, bool? postureCheck}) {
    this.meals = meals ?? this.meals;
    this.postureCheck = postureCheck ?? this.postureCheck;
    notifyListeners();
  }

  Future<void> apply(WidgetRef ref, AppLocalizations l) async {
    final state = await ref.read(appPermissionsProvider).status();
    if (!state.has(AppPermission.notifications)) return;
    final actions = ref.read(goalReminderActionsProvider);
    for (final (on, kind) in [
      (meals, GoalReminderKind.meals),
      (postureCheck, GoalReminderKind.postureCheck),
    ]) {
      if (!on) continue;
      await actions.turnOn(
        GoalReminder(
          kind: kind,
          routineId: null,
          days: kind.defaultDays,
          times: kind.defaultTimes,
        ),
        l,
      );
    }
  }
}

/// Last setup step: what the app may use, each optional, plus a couple of
/// useful reminders to start with.
class PermissionsPage extends ConsumerWidget {
  const PermissionsPage({super.key, required this.reminders});
  final StarterReminders reminders;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      children: [
        const SizedBox(height: AppSpacing.xl),
        Icon(
          Icons.verified_user_outlined,
          size: 48,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: AppSpacing.lg),
        Semantics(
          header: true,
          child: Text(l.permTitle, style: theme.textTheme.headlineSmall),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(l.permIntro, style: theme.textTheme.bodyMedium),
        const SizedBox(height: AppSpacing.md),
        const PermissionList(showAllowAll: true),
        const SizedBox(height: AppSpacing.lg),
        Text(l.permStartReminders, style: theme.textTheme.titleSmall),
        ListenableBuilder(
          listenable: reminders,
          builder: (_, _) => Column(
            children: [
              CheckboxListTile(
                key: const Key('starter-meals'),
                contentPadding: EdgeInsets.zero,
                value: reminders.meals,
                onChanged: (v) => reminders.set(meals: v),
                title: Text(GoalReminderKind.meals.title(l)),
                subtitle: Text(GoalReminderKind.meals.info(l)),
              ),
              CheckboxListTile(
                key: const Key('starter-posture'),
                contentPadding: EdgeInsets.zero,
                value: reminders.postureCheck,
                onChanged: (v) => reminders.set(postureCheck: v),
                title: Text(GoalReminderKind.postureCheck.title(l)),
                subtitle: Text(GoalReminderKind.postureCheck.info(l)),
              ),
            ],
          ),
        ),
        Text(
          l.permStartRemindersNote,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
