// call the requestExactAlarmsPermission() exposed by the AndroidFlutterNotificationsPlugin class so that the user can grant the permission via the app
import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/Model/task_model.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();
  Future<void> initializeNotifications() async {
    const initSettingsAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
    );
    await notificationsPlugin.initialize(initSettings);
  }

  NotificationDetails notificationDetails() {
    return NotificationDetails(
        android: AndroidNotificationDetails("channelId", "channelName",
            channelDescription: "Channel Description",
            importance: Importance.max,
            priority: Priority.max));
  }

  Future<void> showNotifications() async {
    return notificationsPlugin.show(0, "title", "body", notificationDetails());
  }

  Future<void> requestExactPermission() async {
    final bool? granted = await notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();

    if (granted == true) {
      log("Notification permission granted");
    } else {
      log("Notification permission denied");
    }
  }

  Future<void> requestPermission() async {
    final bool? granted = await notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    if (granted == true) {
      log("Notification permission granted");
    } else {
      log("Notification permission denied");
    }
  }

  Future<void> setNotifications(TaskModel obj) async {
    Map<int, String> notiyTimeMap = obj.timeMap ?? {};
    String date = obj.date;

    if (notiyTimeMap.isNotEmpty) {
      for (var entry in notiyTimeMap.entries) {
        int id = entry.key;
        String time = entry.value;
        tz.TZDateTime scheduleTime = convertToTZDateTime(date, time);
        await notificationsPlugin.zonedSchedule(
            id,
            obj.taskName,
            obj.taskDescription ?? "Complete your tasks!!!",
            scheduleTime,
            notificationDetails(),
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
      }
    }
  }

  tz.TZDateTime convertToTZDateTime(String date, String time) {
    DateTime parsedDate = DateFormat("dd/MM/yyyy").parse(date);
    DateTime parsedTime = DateFormat("h:mm a").parse(time);

    DateTime combinedDateTime = DateTime(
      parsedDate.year,
      parsedDate.month,
      parsedDate.day,
      parsedTime.hour,
      parsedTime.minute,
    );

    return tz.TZDateTime.from(combinedDateTime, tz.local);
  }
}
