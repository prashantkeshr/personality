import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personality/core/security/app_lock.dart';
import 'package:personality/features/settings/app_settings.dart';

import '../helpers/app_harness.dart';

class FakeBiometrics implements Biometrics {
  FakeBiometrics({this.succeed = true, this.device = DeviceAuth.success});
  bool succeed;

  /// What the phone's screen-lock prompt answers.
  DeviceAuth device;
  var asked = 0;
  var deviceAsked = 0;
  @override
  Future<bool> available() async => true;
  @override
  Future<bool> authenticate(String reason) async {
    asked++;
    return succeed;
  }

  @override
  Future<bool> deviceLockAvailable() async => device != DeviceAuth.noLock;
  @override
  Future<DeviceAuth> authenticateDevice(String reason) async {
    deviceAsked++;
    return device;
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
        tester
            .binding
            .renderViews
            .first
            .owner!
            .semanticsOwner!
            .rootSemanticsNode!,
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

  test('phone screen lock mode keeps no PIN and accepts none', () async {
    final store = MemoryLockStore();
    final vault = PinVault(store, iterations: 1000);
    await vault.setPin('2468');
    await vault.useDevice();
    expect(await vault.enabled(), isTrue);
    expect(await vault.deviceMode(), isTrue);
    expect(store.values.containsKey('lock.pin'), isFalse);
    // Nothing typed can stand in for the phone's own lock.
    expect(await vault.verify('2468'), isFalse);
    await vault.setPin('1357');
    expect(await vault.deviceMode(), isFalse);
    await vault.disable();
    expect(await vault.enabled(), isFalse);
  });

  testWidgets('turn on the phone screen lock; it unlocks the app on start', (
    tester,
  ) async {
    final bio = FakeBiometrics();
    final app = AppHarness(tester);
    await app.start(onboarded, biometrics: bio);
    await app.tapAndSettle(find.byTooltip('Settings'));
    await app.tapAndSettle(find.byKey(const Key('app-lock')));
    await io(app, tester);
    await tester.pumpAndSettle();
    await app.tapAndSettle(find.byKey(const Key('lock-method-device')));
    await io(app, tester);
    await tester.pumpAndSettle();
    expect(bio.deviceAsked, 1); // confirmed once before turning on
    expect(find.text("Unlocks with your phone's screen lock"), findsOneWidget);
    expect(find.byKey(const Key('app-lock-biometric')), findsNothing);
    await app.dispose();

    // Next start: locked, and the phone's prompt opens by itself.
    final again = AppHarness(tester);
    again.lockStore.values.addAll(app.lockStore.values);
    final bio2 = FakeBiometrics(device: DeviceAuth.failed);
    await again.start(onboarded, biometrics: bio2);
    await io(again, tester);
    expect(bio2.deviceAsked, 1);
    expect(find.byKey(const Key('unlock-pad')), findsNothing);
    expect(find.text('Not unlocked. Try again.'), findsOneWidget);
    bio2.device = DeviceAuth.success;
    await tester.tap(find.byKey(const Key('unlock-device')).last);
    await io(again, tester);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('unlock-device')), findsNothing);
    expect(find.text('Today'), findsOneWidget);
    await again.dispose();
  });

  testWidgets('if the phone loses its screen lock, the app lock turns off', (
    tester,
  ) async {
    final app = AppHarness(tester);
    await app.run(() => PinVault(app.lockStore).useDevice());
    final bio = FakeBiometrics(device: DeviceAuth.noLock);
    await app.start(onboarded, biometrics: bio);
    await io(app, tester);
    expect(find.byKey(const Key('unlock-device')), findsNothing);
    expect(find.textContaining('no longer has a screen lock'), findsOneWidget);
    expect(await app.run(() => PinVault(app.lockStore).enabled()), isFalse);
    // Let the notice time out.
    await tester.pump(const Duration(seconds: 6));
    await app.dispose();
  });

  testWidgets('switching from the phone lock to a PIN asks the phone first', (
    tester,
  ) async {
    final app = AppHarness(tester);
    await app.run(() => PinVault(app.lockStore).useDevice());
    final bio = FakeBiometrics();
    await app.start(onboarded, biometrics: bio);
    await io(app, tester); // auto-prompt unlocks
    await tester.pumpAndSettle();
    await app.tapAndSettle(find.byTooltip('Settings'));
    bio.device = DeviceAuth.failed;
    await app.tapAndSettle(find.byKey(const Key('lock-switch-pin')));
    await io(app, tester);
    expect(find.byKey(const Key('pin-1')), findsNothing); // refused
    bio.device = DeviceAuth.success;
    await app.tapAndSettle(find.byKey(const Key('lock-switch-pin')));
    await io(app, tester);
    await tester.pumpAndSettle();
    await type(app, tester, '1357');
    await type(app, tester, '1357');
    await tester.pumpAndSettle();
    expect(find.text('Unlocks with an app PIN'), findsOneWidget);
    expect(await app.run(() => PinVault(app.lockStore).deviceMode()), isFalse);
    await app.dispose();
  });
}
