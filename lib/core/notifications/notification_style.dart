import 'dart:convert';
import 'dart:typed_data';

/// Reminder sounds. The bundled ones are Personality's own, synthesised for
/// the app (android/app/src/main/res/raw/snd_*.wav).
enum ReminderSound {
  system,
  silent,
  chime,
  bell,
  marimba,
  kalimba,
  zenBowl,
  droplet,
  pop,
  rise,
  harp,
  sparkle,
  pulse,
  birdsong;

  bool get bundled => this != system && this != silent;

  /// Android raw resource name, e.g. `snd_zen_bowl`.
  String get resource => switch (this) {
    zenBowl => 'snd_zen_bowl',
    _ => 'snd_$name',
  };

  static ReminderSound fromName(String? n) =>
      values.firstWhere((s) => s.name == n, orElse: () => pulse);
}

enum VibrationLevel {
  off,
  gentle,
  standard,
  strong;

  /// Off/on durations in milliseconds; null means the phone's default.
  Int64List? get pattern => switch (this) {
    off || standard => null,
    gentle => Int64List.fromList([0, 120]),
    strong => Int64List.fromList([0, 450, 200, 450, 200, 450]),
  };

  static VibrationLevel fromName(String? n) =>
      values.firstWhere((v) => v.name == n, orElse: () => standard);
}

/// How reminder notifications look, sound and behave.
class NotificationStyle {
  const NotificationStyle({
    this.sound = ReminderSound.pulse, // the app's own default
    this.vibration = VibrationLevel.standard,
    this.popUp = true,
    this.hideOnLockScreen = false,
    this.snoozeMinutes = 10,
  });

  final ReminderSound sound;
  final VibrationLevel vibration;

  /// Shows briefly over other apps (high importance), not only in the shade.
  final bool popUp;

  /// Shows only "Personality" on the lock screen, not the reminder text.
  final bool hideOnLockScreen;
  final int snoozeMinutes;

  static const snoozeChoices = [5, 10, 15, 30];

  /// Android fixes a channel's sound, vibration and importance once it
  /// exists, so each combination gets its own channel.
  String get channelId =>
      'reminders_${sound.name}_${vibration.name}_${popUp ? 'pop' : 'quiet'}';

  NotificationStyle copyWith({
    ReminderSound? sound,
    VibrationLevel? vibration,
    bool? popUp,
    bool? hideOnLockScreen,
    int? snoozeMinutes,
  }) => NotificationStyle(
    sound: sound ?? this.sound,
    vibration: vibration ?? this.vibration,
    popUp: popUp ?? this.popUp,
    hideOnLockScreen: hideOnLockScreen ?? this.hideOnLockScreen,
    snoozeMinutes: snoozeMinutes ?? this.snoozeMinutes,
  );

  Map<String, Object> toJson() => {
    'sound': sound.name,
    'vibration': vibration.name,
    'popUp': popUp,
    'hide': hideOnLockScreen,
    'snooze': snoozeMinutes,
  };

  factory NotificationStyle.fromJson(Map<String, dynamic> j) =>
      NotificationStyle(
        sound: ReminderSound.fromName(j['sound'] as String?),
        vibration: VibrationLevel.fromName(j['vibration'] as String?),
        popUp: j['popUp'] as bool? ?? true,
        hideOnLockScreen: j['hide'] as bool? ?? false,
        snoozeMinutes: switch (j['snooze']) {
          final int m when snoozeChoices.contains(m) => m,
          _ => 10,
        },
      );

  static NotificationStyle parse(String? raw) {
    if (raw == null) return const NotificationStyle();
    try {
      return NotificationStyle.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      return const NotificationStyle();
    }
  }

  String encode() => jsonEncode(toJson());

  @override
  bool operator ==(Object other) =>
      other is NotificationStyle &&
      other.sound == sound &&
      other.vibration == vibration &&
      other.popUp == popUp &&
      other.hideOnLockScreen == hideOnLockScreen &&
      other.snoozeMinutes == snoozeMinutes;

  @override
  int get hashCode =>
      Object.hash(sound, vibration, popUp, hideOnLockScreen, snoozeMinutes);
}
