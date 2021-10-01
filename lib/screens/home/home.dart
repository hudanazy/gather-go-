//import 'dart:html';

//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:gather_go/Models/EventInfo.dart';
import 'package:gather_go/screens/home/profile_form.dart';
import 'package:gather_go/services/auth.dart';
// import 'package:gather_go/services/database.dart';
// import 'package:provider/provider.dart';
// import 'package:gather_go/screens/home/event_list.dart';
// import 'package:gather_go/screens/home/user_list.dart';
// import 'package:gather_go/Models/ProfileOnScreen.dart';
import 'package:gather_go/screens/home/createEvent.dart';
import 'package:gather_go/screens/home/nav.dart';
//import 'package:gather_go/shared/gradient_app_bar.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    createEvent(),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // final AuthService _auth = AuthService();
// Widget build(BuildContext context) {
//     return Provider<Example>(
//       create: (_) => Example(),
//       // we use `builder` to obtain a new `BuildContext` that has access to the provider
//       builder: (context) {
//         // No longer throws
//         return Text(context.watch<Example>()),
//       }
//     ),
//   }
  //final uesrList initial = uesrList();
  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
              child: ProfileForm(),
            );
          });
    }

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      //body: EventList(),
      bottomNavigationBar: MyBottomBarDemo(),
    );

    //StreamProvider<List<EventInfo>?>.value(
    //   value: DatabaseService().eventss,
    //   initialData: null,
    //   child: Scaffold(
    //     backgroundColor: Colors.brown[50],
    //     appBar: AppBar(
    //         title: Text("Events"),
    //         backgroundColor: Colors.white,
    //         elevation: 0.0,
    //         actions: <Widget>[
    //           TextButton.icon(
    //             onPressed: () {
    //               _showSettingsPanel();
    //             },
    //             icon: Icon(Icons.person),
    //             label: Text("Profile"),
    //           ),
    //           TextButton.icon(
    //             onPressed: () async {
    //               await _auth.SignOut();
    //             },
    //             icon: Icon(Icons.logout_rounded),
    //             label: Text("Logout"),
    //           ),
    //         ]),
    //     body: EventList(),

    ////events from database
    /////to create event
    // floatingActionButton: FloatingActionButton(
    // onPressed: ()  {
    //   widget.creatEvent();//method in auth.dart
    // },
    //   child: const Icon(Icons.navigation),
    //   backgroundColor: Colors.green,
    // ),

    //home UI goes here

    // ElevatedButton(
    //   child: Text('Log out'),
    //   onPressed: () async {
    //     //await _auth.SignOut();
    //   },
    //   )
    //  ),
  }
}
