import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personality/core/security/app_lock.dart';
import 'package:personality/features/settings/app_settings.dart';

import '../helpers/app_harness.dart';

class FakeBiometrics implements Biometrics {
  FakeBiometrics({this.succeed = true});
  bool succeed;
  var asked = 0;
  @override
  Future<bool> available() async => true;
  @override
  Future<bool> authenticate(String reason) async {
    asked++;
    return succeed;
  }
}

void main() {
  const onboarded = AppSettings(onboardingCompleted: true);

  test('PINs are stored hashed and checked exactly', () async {
    final store = MemoryLockStore();
    final vault = PinVault(store, iterations: 1000);
    expect(await vault.enabled(), isFalse);
    expect(() => vault.setPin('12a4'), throwsArgumentError);
    expect(() => vault.setPin('123'), throwsArgumentError);
    await vault.setPin('2468');
    expect(store.values.values.join(), isNot(contains('2468')));
    expect(await vault.verify('2468'), isTrue);
    expect(await vault.verify('2469'), isFalse);
    expect(await vault.verify('24680'), isFalse);
    await vault.disable();
    expect(await vault.enabled(), isFalse);
  });

  Future<void> io(AppHarness app, WidgetTester tester) async {
    for (var i = 0; i < 10; i++) {
      await app.run(
        () => Future<void>.delayed(const Duration(milliseconds: 40)),
      );
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  Future<void> type(AppHarness app, WidgetTester tester, String pin) async {
    for (final d in pin.split('')) {
      await tester.tap(find.byKey(Key('pin-$d')).last);
      await tester.pump();
    }
    await tester.tap(find.byKey(const Key('pin-ok')).last);
    await io(app, tester);
  }

  testWidgets(
    'turn the lock on in Settings; it locks on start and unlocks with the PIN',
    (tester) async {
      final app = AppHarness(tester);
      await app.start(onboarded);
      await app.tapAndSettle(find.byTooltip('Settings'));
      await app.tapAndSettle(find.byKey(const Key('app-lock')));
      expect(find.text('Choose a PIN'), findsOneWidget);
      await type(app, tester, '1357');
      expect(find.text('Enter the PIN again'), findsOneWidget);
      await type(app, tester, '1357');
      await tester.pumpAndSettle();
      expect(find.text('App lock is on'), findsOneWidget);
      expect(await app.run(() => PinVault(app.lockStore).enabled()), isTrue);
      await app.dispose();

      // A fresh start of the app is locked.
      final again = AppHarness(tester);
      again.lockStore.values.addAll(app.lockStore.values);
      await again.start(onboarded);
      await io(again, tester);
      expect(find.text('Enter your PIN'), findsOneWidget);
      // Screen readers can't reach the app behind the lock.
      final semantics = tester.ensureSemantics();
      await tester.pump();
      final labels = <String>[];
      bool visit(SemanticsNode n) {
        labels.add(n.label);
        n.visitChildren(visit);
        return true;
      }

      visit(
        tester.binding.renderViews.first.owner!.semanticsOwner!.rootSemanticsNode!,
      );
      expect(labels.join('|'), contains('Enter your PIN'));
      expect(labels.join('|'), isNot(contains('Health')));
      semantics.dispose();
      await type(again, tester, '9999');
      expect(find.text('Wrong PIN'), findsOneWidget);
      await type(again, tester, '1357');
      await tester.pumpAndSettle();
      expect(find.text('Enter your PIN'), findsNothing);
      expect(find.text('Today'), findsOneWidget);
      await again.dispose();
    },
  );

  testWidgets('fingerprint unlocks without the PIN', (tester) async {
    final app = AppHarness(tester);
    await app.run(
      () => PinVault(app.lockStore, iterations: 1000).setPin('2468'),
    );
    await app.run(() => PinVault(app.lockStore).setBiometric(true));
    final bio = FakeBiometrics();
    await app.start(onboarded, biometrics: bio);
    await io(app, tester);
    expect(bio.asked, 1); // offered automatically
    await tester.pumpAndSettle();
    expect(find.text('Enter your PIN'), findsNothing);
    await app.dispose();
  });

  testWidgets('keypad keeps 1-2-3 order in Arabic', (tester) async {
    final app = AppHarness(tester);
    await app.run(
      () => PinVault(app.lockStore, iterations: 1000).setPin('2468'),
    );
    await app.start(
      const AppSettings(onboardingCompleted: true, localeCode: 'ar'),
    );
    await io(app, tester);
    final x1 = tester.getCenter(find.byKey(const Key('pin-1')).last).dx;
    final x3 = tester.getCenter(find.byKey(const Key('pin-3')).last).dx;
    expect(x1, lessThan(x3));
    await app.dispose();
  });

  testWidgets('five wrong PINs pause entry', (tester) async {
    final app = AppHarness(tester);
    await app.run(
      () => PinVault(app.lockStore, iterations: 1000).setPin('2468'),
    );
    await app.start(onboarded);
    await io(app, tester);
    for (var i = 0; i < 5; i++) {
      await type(app, tester, '1111');
    }
    expect(find.textContaining('Too many tries'), findsOneWidget);
    await type(app, tester, '2468'); // ignored while waiting
    expect(find.text('Enter your PIN'), findsOneWidget);
    await app.dispose();
  });
}
