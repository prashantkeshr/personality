import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../../domain/services/plan_engine.dart';
import '../logging/app_logger.dart';
import 'notification_style.dart';

/// Localized notification texts, resolved by the caller.
class ReminderTexts {
  const ReminderTexts({
    required this.channelName,
    required this.channelDescription,
    required this.actionDone,
    required this.actionSnooze,
    required this.body,
    this.style = const NotificationStyle(),
  });

  final String channelName;
  final String channelDescription;
  final String actionDone;
  final String actionSnooze;

  /// Notification body for an occurrence, e.g. "Planned for 16:00".
  final String Function(ReminderOccurrence) body;

  /// Sound, vibration and the rest, from Settings.
  final NotificationStyle style;
}

/// A tap or action on a reminder notification.
class ReminderResponse {
  const ReminderResponse({required this.itemId, required this.dayKey, this.action});

  final String itemId;
  final int dayKey;

  /// [ReminderScheduler.actionDone], or null for a plain tap.
  final String? action;
}

/// Schedules reminder notifications. Implementations must degrade quietly:
/// the in-app plan works whether or not notifications are allowed.
abstract interface class ReminderScheduler {
  static const actionDone = 'done';
  static const actionSnooze = 'snooze';
  static const snoozeMinutes = 10;

  Future<void> initialize(void Function(ReminderResponse) onResponse);
  Future<ReminderResponse?> launchResponse();
  Future<bool> notificationsAllowed();
  Future<bool> requestPermission();

  /// Makes pending reminders exactly [occurrences] (snoozes are left alone).
  Future<void> sync(List<ReminderOccurrence> occurrences, ReminderTexts texts);
  Future<void> cancelAll();

  /// Shows one notification now with [texts]' style, to try it out.
  Future<void> showTest(String title, String body, ReminderTexts texts);
}

/// Used in tests and on platforms without notification support.
class NoopReminderScheduler implements ReminderScheduler {
  List<ReminderOccurrence> synced = const [];

  @override
  Future<void> initialize(void Function(ReminderResponse) onResponse) async {}
  @override
  Future<ReminderResponse?> launchResponse() async => null;
  @override
  Future<bool> notificationsAllowed() async => false;
  @override
  Future<bool> requestPermission() async => false;
  @override
  Future<void> sync(
      List<ReminderOccurrence> occurrences, ReminderTexts texts) async {
    synced = occurrences;
  }

  @override
  Future<void> cancelAll() async => synced = const [];

  /// The last test notification's style, for tests.
  NotificationStyle? tested;

  @override
  Future<void> showTest(String title, String body, ReminderTexts texts) async {
    tested = texts.style;
  }
}

const _snoozeBit = 0x40000000;
const _testId = 0x3FFFFFFF;

ReminderResponse? _parse(NotificationResponse r) {
  try {
    final p = jsonDecode(r.payload ?? '') as Map<String, dynamic>;
    return ReminderResponse(
      itemId: p['item'] as String,
      dayKey: p['day'] as int,
      action: r.actionId,
    );
  } catch (_) {
    return null;
  }
}

AndroidNotificationDetails _details(Map<String, dynamic> p) {
  final style = p['style'] is Map
      ? NotificationStyle.fromJson((p['style'] as Map).cast<String, dynamic>())
      : const NotificationStyle();
  return AndroidNotificationDetails(
      style.channelId,
      p['channel'] as String,
      channelDescription: p['channelDescription'] as String,
      category: AndroidNotificationCategory.reminder,
      importance: style.popUp ? Importance.high : Importance.defaultImportance,
      priority: style.popUp ? Priority.high : Priority.defaultPriority,
      playSound: style.sound != ReminderSound.silent,
      sound: style.sound.bundled
          ? RawResourceAndroidNotificationSound(style.sound.resource)
          : null,
      enableVibration: style.vibration != VibrationLevel.off,
      vibrationPattern: style.vibration.pattern,
      visibility: style.hideOnLockScreen
          ? NotificationVisibility.private
          : NotificationVisibility.public,
      // Several reminders at once collapse into one group.
      groupKey: 'com.dhurta.personality.reminders',
      actions: [
        AndroidNotificationAction(
            ReminderScheduler.actionDone, p['done'] as String,
            showsUserInterface: true),
        AndroidNotificationAction(
            ReminderScheduler.actionSnooze, p['snooze'] as String),
      ],
    );
}

Map<String, Object?> _payload(ReminderTexts texts) => {
  'channel': texts.channelName,
  'channelDescription': texts.channelDescription,
  'done': texts.actionDone,
  'snooze': texts.actionSnooze,
  'style': texts.style.toJson(),
};

/// Runs in a background isolate when "Snooze" is pressed. It only needs the
/// notification plugin, so it never opens the encrypted database.
@pragma('vm:entry-point')
Future<void> reminderBackgroundResponse(NotificationResponse r) async {
  if (r.actionId != ReminderScheduler.actionSnooze || r.id == null) return;
  try {
    tz_data.initializeTimeZones();
    final plugin = FlutterLocalNotificationsPlugin();
    await plugin.initialize(
        settings: const InitializationSettings(
            android: AndroidInitializationSettings('@drawable/ic_notification')));
    final p = jsonDecode(r.payload ?? '{}') as Map<String, dynamic>;
    await plugin.zonedSchedule(
      id: r.id! | _snoozeBit,
      title: p['title'] as String?,
      body: p['body'] as String?,
      scheduledDate: tz.TZDateTime.now(tz.UTC).add(Duration(
          minutes: (p['style'] as Map?)?['snooze'] as int? ??
              ReminderScheduler.snoozeMinutes)),
      notificationDetails: NotificationDetails(android: _details(p)),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: r.payload,
    );
  } catch (e, st) {
    AppLogger.error('reminder.snooze', e, st);
  }
}

class LocalNotificationScheduler implements ReminderScheduler {
  final _plugin = FlutterLocalNotificationsPlugin();

  AndroidFlutterLocalNotificationsPlugin? get _android =>
      _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  @override
  Future<void> initialize(void Function(ReminderResponse) onResponse) async {
    tz_data.initializeTimeZones();
    await _plugin.initialize(
      settings: const InitializationSettings(
          android: AndroidInitializationSettings('@drawable/ic_notification')),
      onDidReceiveNotificationResponse: (r) {
        final parsed = _parse(r);
        if (parsed != null) onResponse(parsed);
      },
      onDidReceiveBackgroundNotificationResponse: reminderBackgroundResponse,
    );
  }

  @override
  Future<ReminderResponse?> launchResponse() async {
    final d = await _plugin.getNotificationAppLaunchDetails();
    final r = d?.notificationResponse;
    return (d?.didNotificationLaunchApp ?? false) && r != null ? _parse(r) : null;
  }

  @override
  Future<bool> notificationsAllowed() async =>
      await _android?.areNotificationsEnabled() ?? false;

  @override
  Future<bool> requestPermission() async =>
      await _android?.requestNotificationsPermission() ?? false;

  @override
  Future<void> sync(
      List<ReminderOccurrence> occurrences, ReminderTexts texts) async {
    final wanted = {for (final o in occurrences) o.id};
    for (final p in await _plugin.pendingNotificationRequests()) {
      if (p.id & _snoozeBit == 0 && !wanted.contains(p.id)) {
        await _plugin.cancel(id: p.id);
      }
    }
    for (final o in occurrences) {
      final payload = {
        'item': o.itemId,
        'day': o.dayKey,
        'title': o.title,
        'body': texts.body(o),
        ..._payload(texts),
      };
      await _plugin.zonedSchedule(
        id: o.id,
        title: o.title,
        body: texts.body(o),
        // Absolute instant in UTC: correct across time zones and DST.
        scheduledDate: tz.TZDateTime.from(o.at.toUtc(), tz.UTC),
        notificationDetails: NotificationDetails(android: _details(payload)),
        // Inexact: no special alarm permission; may arrive a few minutes late.
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: jsonEncode(payload),
      );
    }
    await _dropOldChannels(texts.style.channelId);
    if (kDebugMode) AppLogger.info('reminders.synced ${occurrences.length}');
  }

  /// Removes reminder channels from earlier sound choices, so the phone's
  /// own notification settings list only the current one.
  Future<void> _dropOldChannels(String keep) async {
    final android = _android;
    if (android == null) return;
    for (final c in await android.getNotificationChannels() ?? const []) {
      if (c.id.startsWith('reminders') && c.id != keep) {
        await android.deleteNotificationChannel(channelId: c.id);
      }
    }
  }

  @override
  Future<void> cancelAll() => _plugin.cancelAll();

  @override
  Future<void> showTest(String title, String body, ReminderTexts texts) async {
    await _plugin.show(
      id: _testId,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(android: _details(_payload(texts))),
    );
    await _dropOldChannels(texts.style.channelId);
  }
}
