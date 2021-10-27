import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gather_go/main.dart';
import 'package:gather_go/screens/home/home.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
/* import 'dart:io' show Platform;
import 'package:flutter/fix_data.yaml'; */

class NotifactionManager {
  static final NotifactionManager _NotifactionManager =
      NotifactionManager._internal();

  factory NotifactionManager() {
    return _NotifactionManager;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
//here------------------------------------------------
  NotifactionManager._internal();

  Future<void> initNotification() async {
    //  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    //      new FlutterLocalNotificationsPlugin();

    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_flutternotification');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      //iOS: initializationSettingsIOS //not need
    );
//toshow notfication
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: notificationSelected //payload
//-----------------//-----------------------

/*  var android = AndroidNotificationDetails("id", "channel", "description");
    var ios = IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: ios);
    await _flutterLocalNotificationsPlugin.show(
        0, "Demo instant notification", "Tap to do something", platform,
        payload: "Welcome to demo app");
  } */

        //------------------------------------
        );
  }

  Future notificationSelected(String? payload) async {
    if (payload != null) {
      debugPrint('Notifaction payload:' + payload); //heare
    }
    try {
      BuildContext context = MyApp.navigatorKey.currentState!.context;
      // .push(MaterialPageRoute(builder: (context) => Home()));
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));//change home to event datails page 
    } catch (e) {
      print(e);
    }
  }

//---------------------here

  Future<void> showNotification(
      int id, String title, String body, DateTime? day, TimeOfDay? time) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        //tz.TZDateTime.now(tz.local).add(Duration(seconds: 2)),
        //_schedualdaily(TimeOfDay.fromDateTime(time))
        schedualNotification(day, time), //exp 8 am
        const NotificationDetails(
          android: AndroidNotificationDetails(
              "id", 'Main Channel', 'Main channel notifications',
              importance: Importance.max,
              priority: Priority.max,
              icon: '@drawable/ic_flutternotification'),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
        androidAllowWhileIdle: true,
        payload: 'events detaild' //this could be deleted
        );
  }

//time
  tz.TZDateTime schedualNotification(DateTime? day, TimeOfDay? time) { //DateTime? time
    //Time time
    final schedualDate;
    final now = tz.TZDateTime.now(tz.local)//DateTime.now();
        .add(Duration(seconds: 1)); //it didn't work without adding 1 second
    final tommorow = DateTime(
        now.year, now.month, now.day + 1); //+ 1
    final timeToCheck =
        DateTime(day!.year, day.month, day.day);

    print(now);
    print(time.toString());
    print(timeToCheck);
    print(tommorow);
    print(TimeOfDay.now().toString()); //her d
    if (timeToCheck == tommorow)
      schedualDate = tz.TZDateTime(tz.local, now.year, now.month, now.day,
          now.hour, now.minute, now.second);
    else {
      print('tttest time');
      final eventPpreviousDay = day.subtract(Duration(days: 1));
      print(eventPpreviousDay);
      schedualDate = tz.TZDateTime(
          tz.local,
          eventPpreviousDay.year,
          eventPpreviousDay.month,
          eventPpreviousDay.day, //+ 1
          time!.hour-3, //- 3
          time.minute );//+ 30
    }
    //test
    // schedualDate = tz.TZDateTime(tz.local, time!.year, time.month,
    // time.day, time.hour-3, time.minute, time.second);//.toLocal(); and remove -3
    // return schedualDate.isBefore(now)
    //     ? schedualDate.add(Duration(days: 1))
    //     :
    print(schedualDate);
    return schedualDate;
  }

// .............................................attendee notification

  Future<void> showAttendeeNotification(
      int id, String title, String body, DateTime? day, TimeOfDay? time) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        schedualAttendeeNotification(day, time), //exp 8 am
        const NotificationDetails(
          android: AndroidNotificationDetails(
              "id", 'Main Channel', 'Main channel notifications',
              importance: Importance.max,
              priority: Priority.max,
              icon: '@drawable/ic_flutternotification'),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
        androidAllowWhileIdle: true,
        payload: 'events detaild' //this could be deleted
        );
  }

    tz.TZDateTime schedualAttendeeNotification(DateTime? day, TimeOfDay? time) {
    final schedualDate;
    final now = DateTime.now()
        .add(Duration(seconds: 1)); //it didn't work without adding 1 second
    final timeToCheck =
        DateTime(now.year, now.month, now.day, now.hour+2, now.minute);
    final eventTime = DateTime(day!.year, day.month, day.day, time!.hour, time.minute);

    print(now);
    print(time.toString());
    print(timeToCheck);
    print(TimeOfDay.now().toString());
    if (timeToCheck ==eventTime)
      schedualDate = tz.TZDateTime(tz.local, now.year, now.month, now.day,
          now.hour, now.minute, now.second);
    else {
      print('tttest time');
      schedualDate = tz.TZDateTime(
          tz.local,
          day.year,
          day.month,
          day.day, 
          time.hour-2, //- 3
          time.minute);//+ 30
    }
    print(schedualDate);
    return schedualDate;
  }
  
}
