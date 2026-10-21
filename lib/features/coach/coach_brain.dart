import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/logging/app_logger.dart';
import '../../domain/entities/body.dart';
import '../../domain/services/personal_snapshot.dart';
import '../about/about_personality_screen.dart' show personalSnapshotProvider;
import '../health/body_providers.dart';
import '../health/health_providers.dart';
import '../style/style_providers.dart';
import 'coach_knowledge.dart';
import 'coach_model.dart';

/// One message in the chat. Kept in memory only, never stored.
class CoachMessage {
  const CoachMessage({
    required this.fromUser,
    required this.text,
    this.cards = const [],
    this.streaming = false,
    this.offline = false,
  });

  final bool fromUser;
  final String text;

  /// Suggestions with pictures and links, for coach messages.
  final List<KnowledgeItem> cards;
  final bool streaming;

  /// Answered from the knowledge library only (no model).
  final bool offline;

  CoachMessage copyWith({String? text, bool? streaming}) => CoachMessage(
    fromUser: fromUser,
    text: text ?? this.text,
    cards: cards,
    streaming: streaming ?? this.streaming,
    offline: offline,
  );
}

const _languageNames = {
  'en': 'English',
  'hi': 'Hindi',
  'es': 'Spanish',
  'pt': 'Portuguese',
  'id': 'Indonesian',
  'ar': 'Arabic',
};

/// "needsWork" → "needs work", so internal names never reach the answer.
String _words(String name) => name
    .replaceAllMapped(RegExp('[A-Z]'), (m) => ' ${m[0]!.toLowerCase()}')
    .trim();

/// A short, factual summary of the user's own data for the model.
String userContext(
  PersonalSnapshot snap, {
  Set<GoalType> goals = const {},
  String? diet,
  String? region,
  String? undertone,
  int? steps,
  int? activeMinutes,
  double? waterMl,
  int? waterTarget,
}) {
  final lines = <String>[
    if (goals.isNotEmpty) 'Goals: ${goals.map((g) => _words(g.name)).join(', ')}.',
    for (final r in snap.ratings)
      '${r.area.name}: ${_words(r.level.name)}${r.value == null ? '' : ' (${_valueText(r)})'}.',
    if (snap.improvements.isNotEmpty)
      'Most worth improving: ${snap.improvements.map((r) => r.area.name).join(', ')}.',
    if (diet != null) 'Diet: $diet.',
    if (region != null) 'Region: $region.',
    if (undertone != null) 'Skin undertone: $undertone.',
    if (steps != null && steps > 0) 'Steps today: $steps.',
    if (activeMinutes != null && activeMinutes > 0)
      'Active minutes today: $activeMinutes.',
    if (waterMl != null && waterTarget != null)
      'Water today: ${waterMl.round()} of $waterTarget ml.',
  ];
  return lines.isEmpty ? 'No personal data logged yet.' : lines.join('\n');
}

String _valueText(AreaRating r) => switch (r.area) {
  SnapshotArea.body => 'BMI ${r.value!.toStringAsFixed(1)}',
  SnapshotArea.activity => '${r.value!.round()} active min a day',
  SnapshotArea.sleep => '${r.value!.toStringAsFixed(1)} h a night',
  SnapshotArea.hydration => '${(r.value! * 100).round()}% of days on target',
  SnapshotArea.consistency => '${r.value!.round()}-day streak',
  SnapshotArea.posture => '',
};

/// The instruction for the small model: stay grounded, short and safe.
String systemPrompt(String lang, String context, List<KnowledgeItem> notes) {
  final language = _languageNames[lang] ?? 'English';
  final buf = StringBuffer()
    ..writeln(
      "You are the coach inside Personality, a private wellness and style app. "
      "Answer in $language with at most 4 short bullet points and one "
      "closing line. Recommend only items from the notes below, by their exact "
      "names, and pick the ones that best fit the question and the user's data. "
      "Describe them using the notes' own words and numbers; never invent steps, "
      "facts or figures. "
      "If the notes don't cover the question, say so in one line and point to a "
      "section of the app. Be kind and practical, never judge appearance, and "
      "give no medical diagnosis; for pain, illness or injury suggest seeing a "
      "professional. The user can tap cards for every item under your answer.",
    )
    ..writeln()
    ..writeln("User's data:")
    ..writeln(context)
    ..writeln()
    ..writeln('Notes:');
  for (var i = 0; i < notes.length; i++) {
    buf.writeln('[${i + 1}] ${notes[i].title}: ${notes[i].text}');
  }
  return buf.toString();
}

/// Words that ask for something personal ("for me", "my posture").
final _personal = RegExp(
  r'\b(me|my|mine|i|should i|for me|personal)\b|मेरे|मुझे|मेरा',
  caseSensitive: false,
);

/// Retrieval plus the user's own suggested exercises when the question is
/// about them.
List<KnowledgeItem> pickNotes(
  KnowledgeIndex index,
  String question,
  PersonalSnapshot snap,
) {
  final found = index.search(question, k: 6);
  if (!_personal.hasMatch(question)) return found;
  final ids = {for (final f in found) f.id};
  final mine = [
    for (final s in snap.suggestions.take(3))
      for (final it in index.items)
        if (it.id == 'ex:${s.exerciseId}' && !ids.contains(it.id)) it,
  ];
  return [...found.take(4), ...mine, ...found.skip(4)].take(7).toList();
}

class CoachController extends Notifier<List<CoachMessage>> {
  StreamSubscription<String>? _sub;
  bool _busy = false;

  @override
  List<CoachMessage> build() {
    ref.onDispose(() => _sub?.cancel());
    return const [];
  }

  bool get busy => _busy;

  void stop() {
    ref.read(coachRuntimeProvider).stop();
    _sub?.cancel();
    _finish();
  }

  void clear() {
    stop();
    state = const [];
  }

  void _finish() {
    _busy = false;
    if (state.isNotEmpty && state.last.streaming) {
      state = [...state.take(state.length - 1), state.last.copyWith(streaming: false)];
    }
  }

  Future<void> ask(String question, String lang) async {
    final q = question.trim();
    if (q.isEmpty || _busy) return;
    _busy = true;
    final history = state;
    state = [...state, CoachMessage(fromUser: true, text: q)];

    final KnowledgeIndex index;
    try {
      index = await ref.read(coachKnowledgeProvider(lang).future);
    } catch (e, st) {
      AppLogger.error('coach.knowledge', e, st);
      state = [...state, const CoachMessage(fromUser: false, text: '', offline: true)];
      _busy = false;
      return;
    }
    final snap = ref.read(personalSnapshotProvider);
    final notes = pickNotes(index, q, snap);

    final runtime = ref.read(coachRuntimeProvider);
    if (ref.read(coachDeviceCapableProvider)) {
      try {
        final store = await ref.read(coachModelStoreProvider.future);
        if (store.installed) await runtime.load(store.file.path);
      } catch (e, st) {
        // No model, no storage or an engine this phone can't load: the
        // coach still answers from the guides.
        AppLogger.error('coach.load', e, st);
      }
    }
    if (!runtime.loaded) {
      // Search mode: the best notes, quoted directly.
      state = [
        ...state,
        CoachMessage(
          fromUser: false,
          text: notes.isEmpty
              ? ''
              : notes.take(2).map((n) => '${n.title}: ${n.text}').join('\n\n'),
          cards: notes,
          offline: true,
        ),
      ];
      _busy = false;
      return;
    }

    final profile = ref.read(profileProvider).value;
    final today = ref.read(todaySummaryProvider);
    final context = userContext(
      snap,
      goals: ref.read(goalsProvider).value ?? const {},
      diet: profile?.dietPreference?.name,
      region: profile?.region?.name,
      undertone: ref.read(styleProfileProvider).value?.undertone?.name,
      steps: today.steps,
      activeMinutes: today.activeMinutes,
      waterMl: today.waterMl,
      waterTarget: today.targets.waterMl,
    );
    final turns = <CoachTurn>[
      (CoachRole.system, systemPrompt(lang, context, notes)),
      // The last exchange, so follow-ups ("and for beginners?") make sense.
      for (final m in history.skip(history.length > 2 ? history.length - 2 : 0))
        (m.fromUser ? CoachRole.user : CoachRole.assistant, m.text),
      (CoachRole.user, q),
    ];
    state = [
      ...state,
      CoachMessage(fromUser: false, text: '', cards: notes, streaming: true),
    ];
    final buf = StringBuffer();
    _sub = runtime.reply(turns).listen(
      (delta) {
        buf.write(delta);
        state = [
          ...state.take(state.length - 1),
          state.last.copyWith(text: buf.toString()),
        ];
      },
      onError: (Object e, StackTrace st) {
        AppLogger.error('coach.reply', e, st);
        _finish();
      },
      onDone: _finish,
      cancelOnError: true,
    );
  }
}

final coachProvider = NotifierProvider<CoachController, List<CoachMessage>>(
  CoachController.new,
);
