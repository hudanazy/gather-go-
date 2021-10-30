import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gather_go/Models/NewUser.dart';
import 'package:gather_go/screens/messageHandler.dart';
import 'package:gather_go/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gather_go/services/auth.dart';
import 'package:provider/provider.dart';
import 'Models/NewUser.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

//firebase notification
final FirebaseMessaging _fcm = FirebaseMessaging.instance;
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}
const AndroidNotificationChannel channel = AndroidNotificationChannel(
              "id", 'Main Channel', 'Main channel notifications',
              importance: Importance.max,
              //priority: Priority.max,
              //icon: '@drawable/ic_flutternotification'),
        );

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

void main() async {
  // These two lines
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

//firebase notification
final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_flutternotification');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      //iOS: initializationSettingsIOS //not need
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
        String? token= await _fcm.getToken();
        print(token);
        FirebaseMessaging.onMessage.listen((message) async{
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;
      if (notification != null && android != null){
        flutterLocalNotificationsPlugin.show(
          message.data.hashCode,
          message.data['title'],
          message.data['body'],
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              icon: '@drawable/ic_flutternotification',
              priority: Priority.max))
        );}
      });
  //
  runApp(MyApp());
}

/// This is the main application widget.
class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey(debugLabel: "Main Navigator");
  @override
  Widget build(BuildContext context) {
    return StreamProvider<NewUser?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        home: AnimatedSplashScreen(
          //Wrapper(),
          splash: Image.asset(
            'images/logo.PNG',
          ),
          splashIconSize: 490.0,
          splashTransition: SplashTransition.fadeTransition,
          nextScreen: Wrapper(),
          duration: 2500,
        ),
        navigatorKey: navigatorKey,
      ),
    );
  }
}
