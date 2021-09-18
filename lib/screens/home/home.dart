import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gather_go/screens/home/profile_form.dart';
import 'package:gather_go/services/auth.dart';
import 'package:gather_go/services/database.dart';
import 'package:provider/provider.dart';
import 'package:gather_go/screens/home/event_list.dart';
import 'package:gather_go/screens/home/user_list.dart';
import 'package:gather_go/Models/ProfileOnScreen.dart';

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
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
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

    return StreamProvider<List<ProfileOnScreen>?>.value(
      value: DatabaseService().profiles,
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
        body: UserList(),

        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.red,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
              backgroundColor: Colors.green,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined),
              label: 'Add',
              backgroundColor: Colors.purple,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
              backgroundColor: Colors.pink,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.logout),
              label: 'Logout',
              backgroundColor: Colors.pink,
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),

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
      ),
    );
  }
}
