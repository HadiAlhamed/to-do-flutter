import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:to_do_app/models/task.dart';
import 'package:to_do_app/ui/pages/notification_screen.dart';

class NotificationServices {
  //setup + call the method init in the main function , remember to use ensureIntialization
  static FlutterLocalNotificationsPlugin flutterLocalNotificationPlugin =
      FlutterLocalNotificationsPlugin();
  static void onTap(NotificationResponse notificationResponse) async {
    await Get.off(
        () => NotificationScreen(payload: notificationResponse.payload!));
  }

  static Future<void> init(
      {required void Function(NotificationResponse)? onTapCallback}) async {
    InitializationSettings initializationSettings =
        const InitializationSettings(
      android: AndroidInitializationSettings("appicon2"),
      iOS: DarwinInitializationSettings(),
    );
    flutterLocalNotificationPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onTapCallback,
      onDidReceiveBackgroundNotificationResponse: onTapCallback,
    );
  }

  //basic Notification
  static void showBasicNotification() async {
    //we use the id in locking the notification info (eg)
    //title : title of the notification
    //body : body of the notification
    //we control the notification properties such as sound : silent ,
    //notificationsound and so on

    NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'id 1',
        'basic notification',
        importance: Importance.max,
        channelDescription: 'your channel description',
        priority: Priority.high,
        ticker: 'ticker',
        playSound: true, // Enable sound
        enableVibration: true,
        sound: RawResourceAndroidNotificationSound(
            'notification_sound.wav'.split('.').first),
      ),
    );

    await flutterLocalNotificationPlugin.show(
      0,
      "Basic Notification",
      "Notification Body",
      notificationDetails,
      payload: "Ola",
    );
  }

  //Repeated Notification
  static void showRepeatedNotification() async {
    //we use the id in locking the notification info (eg)
    //title : title of the notification
    //body : body of the notification
    //we control the notification properties such as sound : silent ,
    //notificationsound and so on

    NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'id 2',
        'Repeated notification',
        importance: Importance.max,
        channelDescription: 'your channel description',
        priority: Priority.high,
        ticker: 'ticker',
        playSound: true, // Enable sound
        enableVibration: true,
      ),
    );

    await flutterLocalNotificationPlugin.periodicallyShow(
      1,
      "Repeated Notification",
      "Notification Body",
      RepeatInterval.everyMinute,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      payload: "Ola",
    );
  }

  //Scheduled Notification
  static void showScheduledNotification(
    int hour,
    int minutes,
    Task task,
    DateTime dt,
  ) async {
    //we use the id in locking the notification info (eg)
    //title : title of the notification
    //body : body of the notification
    //we control the notification properties such as sound : silent ,
    //notificationsound and so on

    NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        task.id.toString(),
        'Scheduled notification',
        importance: Importance.max,
        channelDescription: 'your channel description',
        priority: Priority.high,
        ticker: 'ticker',
        playSound: true, // Enable sound
        enableVibration: true,

        sound: RawResourceAndroidNotificationSound(
            'notification_sound.wav'.split('.').first),
      ),
    );
    tz.initializeTimeZones(); //Initialize the timzone database
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone)); //fix to chosen date
    String? repeat = task.repeat;
    if (repeat == null || repeat == "none") {
      await flutterLocalNotificationPlugin.zonedSchedule(
        task.id!,
        task.title!,
        task.note!,
        tz.TZDateTime(
          tz.local,
          dt.year,
          dt.month,
          dt.day,
          hour,
          minutes,
        ).subtract(
          Duration(minutes: task.remind ?? 30),
        ),
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        payload:
            '${task.title!}|${task.note!}|${task.startTime} - ${task.endTime}',
      );
    } else {
      await flutterLocalNotificationPlugin.zonedSchedule(
        task.id!,
        task.title!,
        task.note!,
        tz.TZDateTime(
          tz.local,
          dt.year,
          dt.month,
          dt.day,
          hour,
          minutes,
        ).subtract(
          Duration(minutes: task.remind ?? 30),
        ),
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        matchDateTimeComponents: (repeat == 'Daily'
            ? DateTimeComponents.time
            : repeat == 'Weekly'
                ? DateTimeComponents.dayOfWeekAndTime
                : DateTimeComponents.dayOfMonthAndTime),
        payload:
            '${task.title!}|${task.note!}|${task.startTime} - ${task.endTime}',
      );
    }
  }

  //cancel a notification according to its id
  static void cancelNotification(int id) async {
    await flutterLocalNotificationPlugin.cancel(id);
  }

  static void cancelAllNotification() async {
    await flutterLocalNotificationPlugin.cancelAll();
  }
}
