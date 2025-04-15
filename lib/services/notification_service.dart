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
  static final _plugin = FlutterLocalNotificationsPlugin();

  /// Initializes the notification plugin and its dependencies.
  ///
  /// This method performs the following tasks:
  /// 1. Initializes time zones using the [timezone] package.
  /// 2. Sets up platform-specific initialization settings.
  /// 3. Requests necessary permissions for notifications and exact alarms.
  static Future<void> initialize() async {
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

      if (notificationPermission == null ||
          !notificationPermission ||
          exactAlarmsPermission == null ||
          !exactAlarmsPermission) {
        openAppSettings();
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

    const initSettings = InitializationSettings(
      android: androidInitialize,
      iOS: iosInitialize,
      windows: windowsInitialize,
    );

    await _plugin.initialize(initSettings);
  }

  /// Displays an instant notification.
  ///
  /// This method is used to show a notification immediately with the given
  /// title and body.
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
  /// - [body]: The body of the notification
  static Future<void> scheduleReminder(
    String id,
    DateTime time,
    String title,
    String body,
  ) async {
    final now = tz.TZDateTime.now(tz.local);

    if (time.isBefore(now)) {
      throw Exception('Schedule time reminder has already passed: $time');
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

  /// Schedules a deadline notification for a task.
  ///
  /// This method schedules a notification to alert the user when a task's
  /// deadline is approaching or has been reached. If the deadline has already
  /// passed, no notification will be scheduled.
  ///
  /// Parameters:
  /// - [id]: A unique identifier for the notification.
  /// - [time]: The deadline time for the task.
  /// - [title]: The title of the notification.
  /// - [body]: The body of the notification.
  static Future<void> scheduleDeadline(
    String id,
    DateTime time,
    String title,
    String body,
  ) async {
    final now = tz.TZDateTime.now(tz.local);

    if (time.isBefore(now)) {
      throw Exception('Schedule time deadline has already passed: $time');
    }

    await _plugin.zonedSchedule(
      id.hashCode,
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
}
