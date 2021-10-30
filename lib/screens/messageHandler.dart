// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:gather_go/services/database.dart';

// // Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
// //   await Firebase.initializeApp();
// //   print('Handling a background message ${message.messageId}');
// // }
// // const AndroidNotificationChannel channel = AndroidNotificationChannel(
// //               "id", 'Main Channel', 'Main channel notifications',
// //               importance: Importance.max,
// //               //priority: Priority.max,
// //               //icon: '@drawable/ic_flutternotification'),
// //         );

// // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// //       new FlutterLocalNotificationsPlugin();

// class MessageHandler extends StatefulWidget {
//   const MessageHandler({ Key? key }) : super(key: key);

//   @override
//   _MessageHandlerState createState() => _MessageHandlerState();
// }

// class _MessageHandlerState extends State<MessageHandler> {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//   final FirebaseMessaging _fcm = FirebaseMessaging.instance;

//   @override
//   Future<void> initState() async {
//     super.initState();
//     //Firebase.initializeApp();
//     final AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@drawable/ic_flutternotification');

//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//       //iOS: initializationSettingsIOS //not need
//     );
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//     saveDeviceToken();
//     FirebaseMessaging.onMessage.listen((message) async{
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification!.android;
//       if (notification != null && android != null){
//         flutterLocalNotificationsPlugin.show(
//           notification.hashCode,
//           notification.title,
//           notification.body,
//           NotificationDetails(
//             android: AndroidNotificationDetails(
//               channel.id,
//               channel.name,
//               channel.description,
//               icon: '@drawable/ic_flutternotification'
//             )
//           )
//         );
//       }
//       final alert = AlertDialog(
//         title: Text (message.data['title']),
//         content: ListTile(
//           title: Text(message.data['notification']['title']),
//           subtitle: Text(message.data['notification']['body']),
//           ),
//         actions: [
//           TextButton(
//             child: Text("OK",
//                 style: TextStyle(color: Colors.blue)),
//             onPressed: () {
//               Navigator.of(context).pop();
//             }),
//         ],
//       );
//       showDialog(context: context, builder: (context) => alert);
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Container(
      
//     );
//   }
//   saveDeviceToken() async{
//     //String userid = FirebaseAuth.instance.currentUser!.uid;
//     //String? fcmToken = await _fcm.getToken();
//     String? token = await _fcm.getToken();
//     // if (fcmToken != null) {
//     //   var tokenRef =FirebaseFirestore.instance.collection('uestInfo')
//     //   .doc(userid).collection('tokens')
//     //   .doc(fcmToken);
//     //   tokenRef.set({
//     //     'token': fcmToken,
//     //   });
//     // }
//   }
// }