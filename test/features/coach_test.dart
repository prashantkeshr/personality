import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:personality/domain/services/personal_snapshot.dart';
import 'package:personality/features/coach/coach_brain.dart';
import 'package:personality/features/coach/coach_knowledge.dart';
import 'package:personality/features/coach/coach_model.dart';
import 'package:personality/features/settings/app_settings.dart';

import '../helpers/app_harness.dart';

KnowledgeItem item(String id, KnowledgeKind kind, String title, String text,
        [String keywords = '']) =>
    KnowledgeItem(
      id: id,
      kind: kind,
      title: title,
      text: text,
      keywords: keywords,
      route: '/x/$id',
      visual: const SectionVisual(null),
    );

/// Pretends the model is installed.
class _InstalledStore extends CoachModelStore {
  _InstalledStore() : super(dir: '.');
  @override
  bool get installed => true;
}

/// Streams a canned answer and records what it was asked.
class _FakeRuntime implements CoachRuntime {
  List<CoachTurn>? lastTurns;
  bool _loaded = false;
  @override
  bool get loaded => _loaded;
  @override
  Future<void> load(String path) async => _loaded = true;
  @override
  Stream<String> reply(List<CoachTurn> turns, {int maxTokens = 220}) {
    lastTurns = turns;
    return Stream.fromIterable(['Try ', 'Chin tuck ', 'daily.']);
  }

  @override
  void stop() {}
  @override
  Future<void> dispose() async {}
}

void main() {
  const onboarded = AppSettings(onboardingCompleted: true);

  test('search ranks titles and keywords, mixing kinds', () {
    final index = KnowledgeIndex([
      item('a', KnowledgeKind.exercise, 'Chin tuck', 'Draw the chin back to ease the neck.', 'neck posture'),
      item('b', KnowledgeKind.exercise, 'Squat', 'Lower the hips, knees over toes.', 'legs'),
      item('c', KnowledgeKind.section, 'Posture check', 'Check your posture with the camera.', 'posture back neck'),
      item('d', KnowledgeKind.answer, 'How do I control frizz?', 'Use conditioner.', 'hair'),
    ]);
    final r = index.search('exercises for my neck posture');
    expect(r.map((i) => i.id), containsAll(['a', 'c']));
    expect(r.map((i) => i.id), isNot(contains('d')));
    expect(r.first.id, anyOf('a', 'c'));
    expect(index.search('frizzy hair').first.id, 'd'); // prefix match
    expect(index.search('zzzz'), isEmpty);
  });

  test('the prompt carries the user data and numbered notes', () {
    const snap = PersonalSnapshot(
      ratings: [AreaRating(SnapshotArea.posture, RatingLevel.fair)],
      improvements: [AreaRating(SnapshotArea.posture, RatingLevel.fair)],
      suggestions: [],
    );
    final ctx = userContext(snap, steps: 4200, waterMl: 1200, waterTarget: 2500);
    expect(ctx, contains('posture: fair'));
    expect(ctx, contains('Steps today: 4200'));
    final p = systemPrompt('hi', ctx, [
      item('a', KnowledgeKind.exercise, 'Chin tuck', 'Draw the chin back.'),
    ]);
    expect(p, contains('Answer in Hindi'));
    expect(p, contains('[1] Chin tuck: Draw the chin back.'));
    expect(p, contains('no medical diagnosis'));
  });

  Future<void> openCoach(AppHarness app, WidgetTester tester) async {
    GoRouter.of(tester.element(find.byType(Scaffold).first)).push('/growth/coach');
    await app.settle();
    await app.settle();
  }

  Future<void> wait(AppHarness app, WidgetTester tester) async {
    for (var i = 0; i < 12; i++) {
      await app.run(() => Future<void>.delayed(const Duration(milliseconds: 40)));
      await tester.pump(const Duration(milliseconds: 100));
    }
    await tester.pumpAndSettle();
  }

  testWidgets('without the model, the coach answers from the guides with cards', (
    tester,
  ) async {
    final app = AppHarness(tester);
    await app.start(onboarded);
    await openCoach(app, tester);
    // Tests run as a low-tier device: search mode.
    expect(find.text('Smart search mode'), findsOneWidget);
    await app.tapAndSettle(find.byKey(const Key('coach-prompt-1'))); // posture
    await wait(app, tester);
    expect(find.text('From the app\'s guides'), findsOneWidget);
    final cards = find.byWidgetPredicate(
      (w) => w.key is ValueKey<String> && (w.key as ValueKey<String>).value.startsWith('coach-card-'),
    );
    expect(cards, findsWidgets);
    expect(find.byKey(const Key('coach-card-ap:posture')), findsOneWidget);

    // A card opens its section.
    await app.tapAndSettle(find.byKey(const Key('coach-card-ap:posture')));
    final router = GoRouter.of(tester.element(find.byType(Scaffold).last));
    expect(router.state.uri.path, '/analyze/posture');
    await app.dispose();
  });

  testWidgets('with the model, the answer streams in and the cards follow', (
    tester,
  ) async {
    final runtime = _FakeRuntime();
    final app = AppHarness(tester);
    await app.start(onboarded, overrides: [
      coachDeviceCapableProvider.overrideWithValue(true),
      coachModelStoreProvider.overrideWith((ref) async => _InstalledStore()),
      coachRuntimeProvider.overrideWithValue(runtime),
    ]);
    await openCoach(app, tester);
    expect(find.text('Offline AI is ready'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('coach-input')), 'stretches for neck pain');
    await app.tapAndSettle(find.byKey(const Key('coach-send')));
    await wait(app, tester);
    expect(find.text('Try Chin tuck daily.'), findsOneWidget);
    final system = runtime.lastTurns!.first.$2;
    expect(system, contains("User's data:"));
    expect(system, contains('[1] '));
    expect(runtime.lastTurns!.last, (CoachRole.user, 'stretches for neck pain'));
    expect(find.byKey(const Key('coach-answer')), findsOneWidget);
    await app.dispose();
  });

  testWidgets('My Growth opens the coach', (tester) async {
    final app = AppHarness(tester);
    await app.start(onboarded);
    await app.tapAndSettle(find.text('My Growth'));
    await app.tapAndSettle(find.byKey(const Key('open-coach')));
    expect(find.text('AI coach'), findsOneWidget);
    await app.dispose();
  });
}
