import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;


class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =FlutterLocalNotificationsPlugin();

  static Future init({bool initScheduled = false}) async {
    try{
    final initializationSettingsAndroid =
        AndroidInitializationSettings('yoga');
    
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    final details = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if(details!=null && details.didNotificationLaunchApp){

    }
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,);
  }catch (error) {
      // Handle initialization error
      print('Error initializing notifications: $error');
    }
  }

  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        "channel Id",
        "channel Name",
        importance: Importance.max,
        visibility: NotificationVisibility.public,
        icon: '@mipmap/ic_launcher', 
      ),
    );
  }

  static void showScheduledNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduleDate,
  }) async { //=>
  try{
      flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title ?? '',
        body,
        tz.TZDateTime.from(scheduleDate, tz.local),
        // Scheduled time as TZDateTime
        await _notificationDetails(),
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
}catch(error){
  print('Error scheduling notification: $error');
}
  }
}
