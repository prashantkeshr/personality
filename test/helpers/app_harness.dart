import 'dart:async';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:personality/app/personality_app.dart';
import 'package:personality/core/database/app_database.dart';
import 'package:personality/core/providers.dart';
import 'package:personality/features/journey/journey_providers.dart';
import 'package:personality/features/settings/app_settings.dart';

/// Runs the full app on an in-memory database inside a widget test.
///
/// Drift cancels stream queries with a zero-duration timer. Under the fake
/// clock that timer only fires on a pump, so [dispose] must pump after
/// unmounting and before closing the database, or close() waits forever.
class AppHarness {
  AppHarness(this.tester) : db = AppDatabase(NativeDatabase.memory()) {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    // Run with "reduce motion" on: continuous animations (scan lines) would
    // otherwise keep pumpAndSettle from ever settling. The reduce-motion
    // path is part of the product and is exercised here on purpose.
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    // A phone-sized screen (432 × 1280 logical) like the devices we ship
    // to, unless the test already chose a size (e.g. tablet).
    if (tester.view.physicalSize == const Size(2400, 1800)) {
      tester.view.physicalSize = const Size(1080, 3200);
      tester.view.devicePixelRatio = 2.5;
      addTearDown(tester.view.reset);
    }
    // If a test fails before calling dispose(), still unmount the app and
    // flush Drift's pending timer so the next test is not blocked. The close
    // is not awaited here: awaiting it during teardown can deadlock.
    addTearDown(() async {
      if (_disposed) return;
      _disposed = true;
      await tester.pumpWidget(const SizedBox());
      await tester.pump(Duration.zero);
      unawaited(db.close());
    });
  }

  bool _disposed = false;

  final WidgetTester tester;
  final AppDatabase db;

  Future<void> start(
    AppSettings settings, {
    List<Override> overrides = const [],
    bool celebrateBadges = false,
  }) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        initialSettingsProvider.overrideWithValue(settings),
        if (!celebrateBadges) badgeCelebrationsProvider.overrideWithValue(false),
        ...overrides,
      ],
      child: const PersonalityApp(),
    ));
    await settle();
  }

  /// Lets real database I/O complete, then settles frames.
  Future<void> settle() async {
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 30)));
    await tester.pumpAndSettle();
  }

  /// Taps and waits for any database write the tap triggers.
  Future<void> tapAndSettle(Finder finder) async {
    await tester.tap(finder);
    await tester.pump();
    await settle();
    await settle();
  }

  /// Scrolls the current page's main list until [finder] can be tapped
  /// (Home is long: timeline first, journey and stats below).
  Future<void> reveal(Finder finder, {double step = 250}) => tester
      .scrollUntilVisible(finder.hitTestable(), step,
          scrollable: find.byType(Scrollable).first);

  /// Runs real async work (e.g. seeding the database) outside the fake clock.
  Future<T?> run<T>(Future<T> Function() body) => tester.runAsync(body);

  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    await tester.pumpWidget(const SizedBox());
    await tester.pump(Duration.zero);
    await tester.runAsync(db.close);
  }
}
