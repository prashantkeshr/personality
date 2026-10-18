import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../health/health_providers.dart' show clockProvider;
import '../routines/routine_providers.dart';
import 'app_permissions.dart';

extension PermissionLabels on AppPermission {
  IconData get icon => switch (this) {
    AppPermission.notifications => Icons.notifications_active_outlined,
    AppPermission.camera => Icons.photo_camera_outlined,
    AppPermission.activity => Icons.directions_walk,
  };

  String title(AppLocalizations l) => switch (this) {
    AppPermission.notifications => l.permNotifications,
    AppPermission.camera => l.permCamera,
    AppPermission.activity => l.permActivity,
  };

  String info(AppLocalizations l) => switch (this) {
    AppPermission.notifications => l.permNotificationsInfo,
    AppPermission.camera => l.permCameraInfo,
    AppPermission.activity => l.permActivityInfo,
  };
}

/// Asks for one permission and refreshes everything that depends on it.
/// Allowing notifications also switches the app's reminders on.
Future<bool> requestPermission(WidgetRef ref, AppPermission p) async {
  final ok = await ref.read(appPermissionsProvider).request(p);
  ref.invalidate(permissionStateProvider);
  if (p == AppPermission.notifications) {
    ref.invalidate(notificationsAllowedProvider);
    if (ok) await ref.read(reminderSettingsRepositoryProvider).setEnabled(true);
  }
  return ok;
}

/// Re-reads permissions when the app comes back (e.g. from Android
/// settings), so cards and switches show the truth.
class PermissionRefresher extends ConsumerStatefulWidget {
  const PermissionRefresher({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<PermissionRefresher> createState() =>
      _PermissionRefresherState();
}

class _PermissionRefresherState extends ConsumerState<PermissionRefresher> {
  late final _life = AppLifecycleListener(
    onResume: () => ref.invalidate(permissionStateProvider),
  );

  @override
  void dispose() {
    _life.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// Each permission with why it's needed and an Allow button (or a tick).
class PermissionList extends ConsumerWidget {
  const PermissionList({super.key, this.showAllowAll = false});
  final bool showAllowAll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final state = ref.watch(permissionStateProvider).value;
    if (state == null) return const SizedBox(height: 120);
    final missing = state.missing;

    return PermissionRefresher(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final p in AppPermission.values)
            ListTile(
              key: Key('perm-${p.name}'),
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: state.has(p)
                    ? theme.colorScheme.primaryContainer
                    : theme.colorScheme.surfaceContainerHighest,
                child: Icon(
                  p.icon,
                  color: state.has(p)
                      ? theme.colorScheme.onPrimaryContainer
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
              title: Text(p.title(l)),
              subtitle: Text(p.info(l)),
              trailing: state.has(p)
                  ? Tooltip(
                      message: l.permAllowed,
                      child: Icon(
                        Icons.check_circle,
                        color: theme.colorScheme.primary,
                      ),
                    )
                  : TextButton(
                      key: Key('perm-allow-${p.name}'),
                      onPressed: () => requestPermission(ref, p),
                      child: Text(
                        state.askable.contains(p) ||
                                p == AppPermission.notifications
                            ? l.permAllow
                            : l.permOpenSettings,
                      ),
                    ),
            ),
          if (showAllowAll && missing.length > 1) ...[
            const SizedBox(height: AppSpacing.sm),
            FilledButton.tonalIcon(
              key: const Key('perm-allow-all'),
              onPressed: () async {
                for (final p in missing) {
                  await requestPermission(ref, p);
                }
              },
              icon: const Icon(Icons.done_all),
              label: Text(l.permAllowAll),
            ),
          ],
        ],
      ),
    );
  }
}

/// Home: a gentle card when something is still off, at most every few
/// days after "Later".
class PermissionNudgeCard extends ConsumerWidget {
  const PermissionNudgeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final missing = ref.watch(permissionNudgeProvider);
    if (missing.isEmpty) return const SizedBox.shrink();

    return PermissionRefresher(
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: Card(
          key: const Key('perm-nudge'),
          color: theme.colorScheme.secondaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lock_open,
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        l.permNudgeTitle,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  missing.map((p) => p.title(l)).join(' · '),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                ),
                Text(
                  l.permNudgeBody,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    TextButton(
                      key: const Key('perm-later'),
                      onPressed: () => ref
                          .read(appKvProvider)
                          .put(
                            permissionNudgeKey,
                            '${ref.read(clockProvider)().millisecondsSinceEpoch}',
                          ),
                      child: Text(l.permLater),
                    ),
                    const Spacer(),
                    FilledButton(
                      key: const Key('perm-nudge-allow'),
                      onPressed: () async {
                        for (final p in missing) {
                          await requestPermission(ref, p);
                        }
                      },
                      child: Text(l.permAllow),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
