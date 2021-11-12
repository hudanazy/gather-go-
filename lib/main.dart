import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gather_go/Models/NewUser.dart';
import 'package:gather_go/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gather_go/services/auth.dart';
import 'package:provider/provider.dart';
import 'Models/NewUser.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

void main() async {
  // These two lines
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
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
        home: MyAppStatefull(),
        navigatorKey: navigatorKey,
      ),
    );
  }
}

class MyAppStatefull extends StatefulWidget {
  const MyAppStatefull({ Key? key }) : super(key: key);

  @override
  _MyAppStatefullState createState() => _MyAppStatefullState();
}

class _MyAppStatefullState extends State<MyAppStatefull> {
  
  final AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', 
    'High Importance Notifications', 
    'This channel is used for important notifications.', 
    importance: Importance.max,
  );
   var flutterLocalNotificationsPlugin= new FlutterLocalNotificationsPlugin();
   
   _MyAppStatefullState() {
     flutterLocalNotificationsPlugin
  .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
  ?.createNotificationChannel(channel);
   }
   
  // @override
  // void initState() {
  //     print('objecthhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh');
  //     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //       // RemoteNotification? notification = message.notification;
  //       // AndroidNotification? android = message.notification?.android;
  //     print(message.data.toString());
  //   //    if (notification != null && android != null) {
  //   // flutterLocalNotificationsPlugin.show(
  //   //     notification.hashCode,
  //   //     notification.title,
  //   //     notification.body,
  //   //     NotificationDetails(
  //   //       android: AndroidNotificationDetails(
  //   //           channel.id,
  //   //           channel.name,
  //   //           channel.description,
  //   //           //importance: Importance.max,
  //   //           //priority: Priority.max,
  //   //           icon: '@drawable/ic_flutternotification'),
  //   //     ),
  //   //     );
  //   //    }
  //      return;
  // });
  // super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
          //Wrapper(),
          splash: Image.asset(
            'images/logo.PNG',
          ),
          splashIconSize: 490.0,
          splashTransition: SplashTransition.fadeTransition,
          nextScreen: Wrapper(),
          duration: 2500,
        );
  }
}
