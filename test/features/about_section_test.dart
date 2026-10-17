import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personality/features/settings/app_settings.dart';

import '../helpers/app_harness.dart';

void main() {
  const device = MethodChannel('personality/device');
  final calls = <MethodCall>[];
  String? clipboard;

  void mock({required bool mailApp}) {
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(device, (call) async {
      calls.add(call);
      return call.method == 'email' ? mailApp : null;
    });
    messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method == 'Clipboard.setData') {
        clipboard = (call.arguments as Map)['text'] as String;
      }
      return null;
    });
  }

  setUp(() {
    calls.clear();
    clipboard = null;
  });

  Future<AppHarness> openAbout(WidgetTester tester) async {
    final app = AppHarness(tester);
    await app.start(const AppSettings(onboardingCompleted: true));
    await app.tapAndSettle(find.byTooltip('Settings'));
    await tester.scrollUntilVisible(find.byKey(const Key('contact-email')), 300,
        scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();
    return app;
  }

  testWidgets('About shows the maker and the support email', (tester) async {
    mock(mailApp: true);
    final app = await openAbout(tester);
    expect(find.text('Made by dhurta.Inc'), findsOneWidget);
    expect(find.textContaining('support@dhurta.org'), findsOneWidget);

    await app.tapAndSettle(find.byKey(const Key('contact-email')));
    final email = calls.singleWhere((c) => c.method == 'email');
    expect(email.arguments, {'to': 'support@dhurta.org', 'subject': 'Personality app'});
    expect(clipboard, isNull);
    await app.dispose();
  });

  testWidgets('without a mail app the address is copied', (tester) async {
    mock(mailApp: false);
    final app = await openAbout(tester);
    await app.tapAndSettle(find.byKey(const Key('contact-email')));
    expect(clipboard, 'support@dhurta.org');
    expect(find.text('Email address copied'), findsOneWidget);
    await app.dispose();
  });
}
