import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../health/health_providers.dart';
import '../health/body_providers.dart';
import '../today/today_widgets.dart';

/// Part of the day, for the header's colours and icon.
enum DayPhase { morning, afternoon, evening, night }

DayPhase dayPhaseAt(int hour) => hour >= 5 && hour < 12
    ? DayPhase.morning
    : hour >= 12 && hour < 17
        ? DayPhase.afternoon
        : hour >= 17 && hour < 21
            ? DayPhase.evening
            : DayPhase.night;

/// Home's header: a gradient for the time of day, a sun or moon that eases
/// in, the greeting, today's date and the daily-plan ring.
class HomeHero extends ConsumerWidget {
  const HomeHero({super.key});

  static const _gradients = {
    DayPhase.morning: [Color(0xFFFFB74D), Color(0xFFFF8A65)],
    DayPhase.afternoon: [Color(0xFF29B6F6), Color(0xFF26A69A)],
    DayPhase.evening: [Color(0xFF7E57C2), Color(0xFFEC407A)],
    DayPhase.night: [Color(0xFF283593), Color(0xFF0D1442)],
  };

  static const _icons = {
    DayPhase.morning: Icons.wb_sunny_rounded,
    DayPhase.afternoon: Icons.light_mode_rounded,
    DayPhase.evening: Icons.wb_twilight_rounded,
    DayPhase.night: Icons.nightlight_round,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final now = ref.watch(clockProvider)();
    final phase = dayPhaseAt(now.hour);
    final greeting = now.hour < 12
        ? l10n.greetingMorning
        : now.hour < 17
            ? l10n.greetingAfternoon
            : l10n.greetingEvening;
    final name = ref.watch(profileProvider).value?.displayName?.split(' ').first;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final reduce = MediaQuery.disableAnimationsOf(context);
    const onHero = Colors.white;

    return Container(
      key: const Key('home-hero'),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _gradients[phase]!,
        ),
        boxShadow: [
          BoxShadow(
            color: _gradients[phase]!.last.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(children: [
        // The sun or moon drifts in and settles in the corner.
        PositionedDirectional(
          end: -18,
          top: -18,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: reduce ? Duration.zero : const Duration(milliseconds: 1200),
            curve: Curves.easeOutBack,
            builder: (_, v, child) => Opacity(
              opacity: v.clamp(0.0, 1.0),
              child: Transform.rotate(
                angle: (1 - v) * -math.pi / 3,
                child: Transform.scale(scale: 0.6 + 0.4 * v, child: child),
              ),
            ),
            child: Icon(_icons[phase], size: 120, color: onHero.withValues(alpha: 0.22)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Icon(_icons[phase], color: onHero, size: 20),
                  const SizedBox(width: AppSpacing.xs),
                  Flexible(
                    child: Text(
                      name == null || name.isEmpty ? greeting : l10n.greetingNamed(greeting, name),
                      style: theme.textTheme.titleMedium?.copyWith(color: onHero),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ]),
                const SizedBox(height: AppSpacing.xs),
                Semantics(
                  header: true,
                  child: Text(l10n.todayTitle,
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(color: onHero, fontWeight: FontWeight.w700)),
                ),
                Text(DateFormat.yMMMMEEEEd(locale).format(now),
                    style: theme.textTheme.bodyMedium?.copyWith(color: onHero.withValues(alpha: 0.9))),
              ]),
            ),
            const SizedBox(width: AppSpacing.sm),
            // The ring keeps the app's own colours on a light pill.
            DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Padding(
                padding: EdgeInsets.fromLTRB(AppSpacing.md, 6, 6, 6),
                child: DailyPlanRing(),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}
