import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gather_go/screens/home/profile_form.dart';
import 'package:gather_go/services/auth.dart';
import 'package:gather_go/services/database.dart';
import 'package:provider/provider.dart';
import 'package:gather_go/screens/home/event_list.dart';
import 'package:gather_go/screens/home/user_list.dart';
import 'package:gather_go/Models/UserOnScreen.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

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

    return StreamProvider<List<UserOnScreen>?>.value(
      value: DatabaseService().users,
      initialData: null,
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
            title: Text("Events"),
            backgroundColor: Colors.white,
            elevation: 0.0,
            actions: <Widget>[
              TextButton.icon(
                onPressed: () {
                  _showSettingsPanel();
                },
                icon: Icon(Icons.person),
                label: Text("Profile"),
              ),
              TextButton.icon(
                onPressed: () async {
                  await _auth.SignOut();
                },
                icon: Icon(Icons.logout_rounded),
                label: Text("Logout"),
              ),
            ]),
        body: UserList(), //events from database
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
      ),
    );
  }
}
