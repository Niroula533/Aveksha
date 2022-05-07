import 'package:aveksha/controllers/userControl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:get/get.dart';
// import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();
  static const firebaseServerKey =
      "AAAAMVFqWSo:APA91bEdYWsRvxsYBOTzcq1TOYsAdMk0wrKPkiE8k3wrz5_oktpgBIjLQGCdoDx91W1GUxvlqyU1-UXYsrtmCp0pvaY4O4SnaMylXyykBVUkTqzrVvP75TIMP7XcbUlMOfO86icI4c5h";

  Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        "aveksha",
        "aveksha",
        importance: Importance.max,
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  static Future unScheduleNotification({required id}) {
    return _notifications.cancel(id);
  }

  static Future showNumbers() async {
    List a = await _notifications.pendingNotificationRequests();
    return a.length;
  }

  static Future init({bool initScheduled = false}) async {
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: iOS);
    await _notifications.initialize(settings,
        onSelectNotification: (payload) async {
      onNotifications.add(payload);
    });
    if (initScheduled) {
      tz.initializeTimeZones();
      // final locationName = await FlutterNativeTimezone.getLocalTimezone();
      const locationName = "Asia/Kathmandu";
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  Future showNotification({
    int id = 99,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notifications.show(id, title, body, await _notificationDetails(),
          payload: payload);

  Future showScheduledNotification(
          {int id = 0,
          String? title,
          String? body,
          String? payload,
          required DateTime scheduledDate}) async =>
      _notifications.zonedSchedule(id, title, body,
          _scheduleDaily(scheduledDate), await _notificationDetails(),
          payload: payload,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time);

  static tz.TZDateTime _scheduleDaily(DateTime time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day,
        time.hour, time.minute, time.second);
    return scheduledDate.isBefore(now)
        ? scheduledDate.add(Duration(days: 1))
        : scheduledDate;
  }

  Future sendRemote(
      {required String title,
      required String body,
      required String topic}) async {await Dio().post('https://fcm.googleapis.com/fcm/send',
        options: Options(headers: {"Authorization": "key=$firebaseServerKey"}),
        data: {
          "to": "/topics/$topic",
          "notification": {"title": title, "body": body}
        });
  }
}
