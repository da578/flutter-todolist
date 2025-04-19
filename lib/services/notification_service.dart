import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

/// Service for managing local notifications.
///
/// This service uses [FlutterLocalNotificationsPlugin] to display notifications
/// and schedule reminder or deadline notifications. It ensures proper handling
/// of time zones, permissions, and platform-specific configurations.
class NotificationService {
  /// The instance of [FlutterLocalNotificationsPlugin] used for notifications.
  static final _plugin = FlutterLocalNotificationsPlugin();

  /// A map to store active timers for countdown notifications.
  ///
  /// Each notification ID is associated with a timer that updates the countdown.
  static final Map<String, Timer> _activeTimers = {};

  /// Initializes the notification plugin and its dependencies.
  ///
  /// This method performs the following tasks:
  /// 1. Initializes time zones using the [timezone] package.
  /// 2. Sets up platform-specific initialization settings.
  /// 3. Requests necessary permissions for notifications and exact alarms.
  static Future<void> initialize() async {
    // Initialize time zones and set the local time zone.
    tz.initializeTimeZones();
    final String localTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTimeZone));

    // Android-specific initialization.
    const androidInitialize = AndroidInitializationSettings(
      '@mipmap/launcher_icon',
    );
    final androidPlugin =
        _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    if (androidPlugin != null) {
      final notificationPermission =
          await androidPlugin.requestNotificationsPermission();
      final exactAlarmsPermission =
          await androidPlugin.requestExactAlarmsPermission();

      // Open app settings if permissions are not granted.
      if (notificationPermission == null ||
          !notificationPermission ||
          exactAlarmsPermission == null ||
          !exactAlarmsPermission) {
        if (!await openAppSettings()) {
          throw Exception(
            'Open App Settings to allow Notifications and Exact Alarms Permissions',
          );
        }
      }
    }

    // iOS-specific initialization.
    const iosInitialize = DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    // Windows-specific initialization.
    const windowsInitialize = WindowsInitializationSettings(
      appName: 'To Do List',
      appUserModelId: 'todolist',
      guid: 'bbbcb6a1-264b-4f2a-83ac-af90e4fed3ef',
    );

    // Combine all platform-specific settings.
    const initSettings = InitializationSettings(
      android: androidInitialize,
      iOS: iosInitialize,
      windows: windowsInitialize,
    );

    // Initialize the plugin with the combined settings.
    await _plugin.initialize(initSettings);
  }

  /// Displays an instant notification.
  ///
  /// This method shows a notification immediately with the given title and body.
  ///
  /// Parameters:
  /// - [title]: The title of the notification (required).
  /// - [body]: The body of the notification (required).
  static Future<void> show(String title, String body) async {
    await _plugin.show(
      0,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'instant_channel',
          'Instant Notifications',
          channelDescription: 'Immediate task notifications',
        ),
      ),
    );
  }

  /// Schedules a reminder notification at a specific time.
  ///
  /// This method schedules a notification to remind the user about a task
  /// at the specified time. If the scheduled time has already passed, no
  /// notification will be scheduled.
  ///
  /// Parameters:
  /// - [id]: A unique identifier for the notification.
  /// - [time]: The scheduled time for the notification.
  /// - [title]: The title of the notification.
  /// - [body]: The body of the notification.
  ///
  /// Throws an error if the scheduled time has already passed.
  static Future<void> scheduleReminder(
    String id,
    DateTime time,
    String title,
    String body,
  ) async {
    final now = tz.TZDateTime.now(tz.local);

    if (time.isBefore(now)) {
      throw Exception('Scheduled time reminder has already passed: $time');
    }

    await _plugin.zonedSchedule(
      id.hashCode,
      title,
      body,
      tz.TZDateTime.from(time, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder_channel',
          'Reminder',
          channelDescription: 'Task reminder notifications',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  /// Schedules two notifications for a task's deadline:
  /// 1. An ongoing countdown notification that cannot be dismissed.
  /// 2. A one-time notification that triggers exactly at the deadline.
  ///
  /// Parameters:
  /// - [id]: A unique identifier for the task.
  /// - [time]: The deadline time for the task.
  /// - [title]: The title of the notification.
  /// - [body]: The body of the notification.
  ///
  /// Throws an error if the deadline time has already passed.
  static Future<void> scheduleDeadline(
    String id,
    DateTime time,
    String title,
    String body,
  ) async {
    final now = tz.TZDateTime.now(tz.local);

    if (time.isBefore(now)) {
      throw Exception('Scheduled time deadline has already passed: $time');
    }

    // Schedule the ongoing countdown notification.
    await _scheduleCountdownNotification(id, time, title, body);

    // Schedule the deadline notification.
    await _scheduleDeadlineNotification(id, time, title, body);
  }

  /// Schedules an ongoing countdown notification.
  ///
  /// This method creates a periodic timer that updates the notification every second
  /// until the deadline is reached.
  ///
  /// Parameters:
  /// - [id]: A unique identifier for the task.
  /// - [time]: The deadline time for the task.
  /// - [title]: The title of the notification.
  /// - [body]: The body of the notification.
  static Future<void> _scheduleCountdownNotification(
    String id,
    DateTime time,
    String title,
    String body,
  ) async {
    if (_activeTimers.containsKey(id)) {
      _activeTimers[id]?.cancel();
      _activeTimers.remove(id);
    }

    int iteration = 0;

    final Timer countdownTimer = Timer.periodic(const Duration(seconds: 1), (
      timer,
    ) async {
      final now = tz.TZDateTime.now(tz.local);
      final remaining = time.difference(now);

      // Stop the timer if the deadline has passed.
      if (remaining.isNegative) {
        timer.cancel();
        await _plugin.cancel('${id}_countdown'.hashCode);
        return;
      }

      // Update the countdown notification.
      final countdownTitle = '$title (Countdown)';
      final countdownBody = 'Time left: ${_formatDuration(remaining)}';

      await _plugin.show(
        '${id}_countdown'.hashCode,
        countdownTitle,
        countdownBody,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'countdown_channel',
            'Countdown',
            channelDescription: 'Ongoing countdown notifications',
            ongoing: true,
            autoCancel: false,
            priority: Priority.high,
            importance: Importance.max,
            silent: iteration > 0,
          ),
        ),
      );

      iteration++;
    });

    _activeTimers[id] = countdownTimer;
  }

  /// Schedules a one-time notification for the task's deadline.
  ///
  /// This method triggers a notification exactly at the specified deadline time.
  ///
  /// Parameters:
  /// - [id]: A unique identifier for the task.
  /// - [time]: The deadline time for the task.
  /// - [title]: The title of the notification.
  /// - [body]: The body of the notification.
  static Future<void> _scheduleDeadlineNotification(
    String id,
    DateTime time,
    String title,
    String body,
  ) async {
    await _plugin.zonedSchedule(
      '${id}_deadline'.hashCode,
      title,
      body,
      tz.TZDateTime.from(time, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'deadline_channel',
          'Deadline',
          channelDescription: 'Task deadline notifications',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  /// Formats a [Duration] into a human-readable string (e.g., "1h 30m 45s").
  ///
  /// Parameters:
  /// - [duration]: The duration to format.
  ///
  /// Returns a formatted string representing the duration.
  static String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    return '${hours}h ${minutes}m ${seconds}s';
  }
}
