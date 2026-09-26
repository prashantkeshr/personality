import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:personality/app/personality_app.dart';
import 'package:personality/core/database/app_database.dart';
import 'package:personality/core/providers.dart';
import 'package:personality/features/settings/app_settings.dart';

/// Runs the full app on an in-memory database inside a widget test.
///
/// Drift cancels stream queries with a zero-duration timer. Under the fake
/// clock that timer only fires on a pump, so [dispose] must pump after
/// unmounting and before closing the database, or close() waits forever.
class AppHarness {
  AppHarness(this.tester) : db = AppDatabase(NativeDatabase.memory()) {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  }

  final WidgetTester tester;
  final AppDatabase db;

  Future<void> start(
    AppSettings settings, {
    List<Override> overrides = const [],
  }) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        initialSettingsProvider.overrideWithValue(settings),
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

  /// Runs real async work (e.g. seeding the database) outside the fake clock.
  Future<T?> run<T>(Future<T> Function() body) => tester.runAsync(body);

  Future<void> dispose() async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(Duration.zero);
    await tester.runAsync(db.close);
  }
}
