import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:personality/core/device/speech.dart';
import 'package:personality/data/repositories/app_kv.dart';
import 'package:personality/domain/entities/exercise_library.dart';
import 'package:personality/domain/entities/health.dart' show ExerciseCategory;
import 'package:personality/domain/services/workout_plan.dart';
import 'package:personality/features/exercise/voice_cues.dart';
import 'package:personality/features/settings/app_settings.dart';
import 'package:personality/l10n/app_localizations.dart';

import '../helpers/app_harness.dart';

/// Records what would be spoken.
class FakeSpeech extends Speech {
  final said = <String>[];
  @override
  Future<void> say(String text, String lang) async => said.add(text);
  @override
  Future<void> stop() async {}
}

void main() {
  const onboarded = AppSettings(onboardingCompleted: true);

  Future<void> wait(AppHarness app, WidgetTester tester) async {
    for (var i = 0; i < 8; i++) {
      await app.run(() => Future<void>.delayed(const Duration(milliseconds: 30)));
      await tester.pump(const Duration(milliseconds: 100));
    }
    await tester.pumpAndSettle();
  }

  void push(WidgetTester tester, String path) =>
      GoRouter.of(tester.element(find.byType(Scaffold).first)).push(path);

  testWidgets('build a workout: pick exercises, reps or time, rounds; it joins the list',
      (tester) async {
    final app = AppHarness(tester);
    await app.start(onboarded);
    push(tester, '/health/exercise/programs');
    await wait(app, tester);
    await app.tapAndSettle(find.byKey(const Key('build-workout')));
    expect(find.text('Build your own workout'), findsOneWidget);
    // Save waits for a name and an exercise.
    expect(tester.widget<TextButton>(find.byKey(const Key('builder-save'))).onPressed, isNull);

    await tester.enterText(find.byKey(const Key('builder-name')), 'Leg day');
    await app.tapAndSettle(find.byKey(const Key('builder-add')));
    await tester.enterText(find.byKey(const Key('picker-search')), 'squat');
    await tester.pumpAndSettle();
    await app.tapAndSettle(find.byKey(const Key('pick-squat')));
    await app.tapAndSettle(find.byKey(const Key('builder-amount-0-plus')));
    expect(find.text('11 reps'), findsOneWidget);

    await app.tapAndSettle(find.byKey(const Key('builder-add')));
    await tester.enterText(find.byKey(const Key('picker-search')), 'plank');
    await tester.pumpAndSettle();
    await app.tapAndSettle(find.byKey(const Key('pick-plank')));
    await app.tapAndSettle(find.descendant(
        of: find.byKey(const Key('builder-kind-1')), matching: find.text('Time')));
    expect(find.text('30 s'), findsOneWidget);
    await app.tapAndSettle(find.byKey(const Key('builder-rounds-plus')));
    expect(find.byKey(const Key('builder-total')), findsOneWidget);

    await app.tapAndSettle(find.byKey(const Key('builder-save')));
    await wait(app, tester);
    // Lands on the new workout's page.
    expect(find.text('Leg day'), findsOneWidget);
    expect(find.text('Your own workout'), findsOneWidget);
    expect(find.text('2 rounds'), findsOneWidget);

    final saved = await app.run(() => AppKv(app.db).watchPrefix('myworkout.').first);
    final p = WorkoutProgram.fromJson(jsonDecode(saved!.values.single) as Map<String, dynamic>);
    expect(p.steps.map((s) => s.exercise), ['squat', 'plank']);
    expect(p.steps[0].reps, 11);
    expect(p.steps[1].seconds, 30);
    expect(p.rounds, 2);

    // It appears in the workout list, marked as the user's own.
    await tester.pageBack();
    await tester.pumpAndSettle();
    await wait(app, tester);
    await app.reveal(find.textContaining('Mine'));
    expect(find.text('Leg day'), findsOneWidget);

    // Edit, then delete it.
    await app.tapAndSettle(find.text('Leg day'));
    await app.tapAndSettle(find.byKey(const Key('workout-edit')));
    expect(find.text('Edit workout'), findsOneWidget);
    await app.tapAndSettle(find.byKey(const Key('builder-remove-1')));
    await app.tapAndSettle(find.byKey(const Key('builder-delete')));
    await app.tapAndSettle(find.byKey(const Key('builder-delete-confirm')));
    await wait(app, tester);
    final left = await app.run(() => AppKv(app.db).watchPrefix('myworkout.').first);
    expect(left, isEmpty);
    await app.dispose();
  });

  testWidgets('the player speaks each step and counts down; voice can be turned off',
      (tester) async {
    final speech = FakeSpeech();
    final app = AppHarness(tester);
    const p = WorkoutProgram(
      id: 'my_1',
      title: {'en': 'Quick one'},
      summary: {},
      category: ExerciseCategory.generalFitness,
      steps: [
        ProgramStep(exercise: 'squat', reps: 8, rest: 5),
        ProgramStep(exercise: 'reverse_lunge', seconds: 10, sides: true),
      ],
    );
    await app.run(() => AppKv(app.db).put('myworkout.my_1', jsonEncode(p.toJson())));
    await app.start(onboarded, overrides: [speechProvider.overrideWithValue(speech)]);
    push(tester, '/health/exercise/programs/my_1/play');
    await wait(app, tester);
    expect(speech.said.first, 'Get ready. First: Bodyweight squat');

    await tester.pump(const Duration(seconds: 5));
    await tester.pump();
    expect(speech.said, containsAllInOrder(['3', '2', '1', 'Bodyweight squat. 8 reps']));
    await app.tapAndSettle(find.byKey(const Key('segment-done')));
    expect(speech.said.last, 'Rest. Next: Reverse lunge');

    // Turning it off keeps the player quiet and is remembered.
    await app.tapAndSettle(find.byKey(const Key('workout-voice')));
    await wait(app, tester);
    final count = speech.said.length;
    await app.tapAndSettle(find.byKey(const Key('workout-skip')));
    expect(speech.said.length, count);
    expect(await app.run(() => AppKv(app.db).get('voice.cues')), '0');
    await app.dispose();
  });

  test('switching sides gets its own cue', () async {
    final l = await AppLocalizations.delegate.load(const Locale('en'));
    String name(String? id) => id == 'lunge' ? 'Lunge' : '';
    const side1 = WorkoutSegment(kind: SegmentKind.work, exercise: 'lunge', reps: 8, side: 1);
    const pause = WorkoutSegment(kind: SegmentKind.rest, exercise: 'lunge', seconds: 5);
    const side2 = WorkoutSegment(kind: SegmentKind.work, exercise: 'lunge', reps: 8, side: 2);
    expect(voiceCueFor(l, pause, side1, name), 'Switch sides');
    expect(voiceCueFor(l, side2, pause, name), 'Other side. Lunge. 8 reps');
  });
}
