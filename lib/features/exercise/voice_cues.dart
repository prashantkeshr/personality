import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/services/workout_plan.dart';
import '../../l10n/app_localizations.dart';
import '../permissions/app_permissions.dart' show appKvProvider;

/// Spoken cues in the workout player; on unless the user turns them off.
const _voiceKey = 'voice.cues';

final voiceCuesProvider = StreamProvider<bool>((ref) => ref
    .watch(appKvProvider)
    .watchPrefix(_voiceKey)
    .map((m) => m[_voiceKey] != '0'));

Future<void> setVoiceCues(WidgetRef ref, bool on) =>
    ref.read(appKvProvider).put(_voiceKey, on ? '1' : '0');

/// What to say when the player enters [seg]. [previous] is the segment
/// before it; [name] turns an exercise id into its name.
String? voiceCueFor(
  AppLocalizations l,
  WorkoutSegment seg,
  WorkoutSegment? previous,
  String Function(String? id) name,
) {
  switch (seg.kind) {
    case SegmentKind.ready:
      return l.voiceGetReady(name(seg.exercise));
    case SegmentKind.rest:
      // The short pause between the two sides of one exercise.
      if (previous?.kind == SegmentKind.work && previous?.side == 1) return l.voiceSwitchSides;
      return l.voiceRestNext(name(seg.exercise));
    case SegmentKind.work:
      if (seg.side == 2) {
        return seg.seconds != null
            ? '${l.voiceOtherSide}. ${l.voiceWorkSeconds(name(seg.exercise), seg.seconds!)}'
            : '${l.voiceOtherSide}. ${l.voiceWorkReps(name(seg.exercise), seg.reps ?? 10)}';
      }
      return seg.seconds != null
          ? l.voiceWorkSeconds(name(seg.exercise), seg.seconds!)
          : l.voiceWorkReps(name(seg.exercise), seg.reps ?? 10);
  }
}
