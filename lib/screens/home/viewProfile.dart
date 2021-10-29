import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gather_go/Models/ProfileOnScreen.dart';
import 'package:gather_go/screens/admin/adminNav.dart';
import 'package:gather_go/screens/home/editProfile.dart';
import 'package:gather_go/screens/home/edit_profile_form.dart';
import 'package:gather_go/services/auth.dart';
import 'package:gather_go/services/database.dart';
import 'package:gather_go/shared/contants.dart';
import 'package:gather_go/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:gather_go/Models/NewUser.dart';
import 'package:gather_go/shared/build_appbar.dart';
import 'package:gather_go/Models/UesrInfo.dart';
import 'dart:io';
import 'package:gather_go/shared/profile_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gather_go/services/database.dart';

import 'MyEvents.dart';

// ignore: camel_case_types
class viewProfile extends StatefulWidget {
  final DocumentSnapshot? user;
  viewProfile({required this.user});
  @override
  _viewProfile createState() => _viewProfile();
}

// ignore: camel_case_types
class _viewProfile extends State<viewProfile> {
  final _formKey = GlobalKey<FormState>(); //for form

  String? _currentName;
  String? _currentBio;
//widget.user?.get('name')
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    String status = widget.user?.get('status');
    String UserName = widget.user?.get('name');
    //DatabaseService(uid: user.uid).profileData,
    String state;
    Color stateColor = Colors.grey;
    if (status == "Available") {
      state = "Available";
      stateColor = Colors.lightGreen;
    } else if (status == "Busy") {
      state = "Disapprove";
      stateColor = Colors.red[200]!;
    } else if (status == 'At School') {
      state = 'At School';
      stateColor = Colors.yellow;
    } else if (status == 'At Work') {
      state = 'At Work';
      stateColor = Colors.yellow;
    } else if (status == 'In a meeting') {
      state = 'In a meeting';
      stateColor = Colors.orange[300]!;
    } else if (status == 'Sleeping') {
      state = 'Sleeping';
      stateColor = Colors.lightGreen;
    } else if (status == 'Away') {
      state = 'Away';
      stateColor = Colors.grey;
    }
    return Container(
        height: 640,
        width: 500,
        child: ListView(children: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 52),
              child: Column(children: [
                SizedBox(
                  height: 25,
                ),
                Center(
                  child: Stack(
                    children: [
                      ClipOval(
                        child: Material(
                          color: Colors.transparent,
                          child: widget.user?.get('imageUrl') == ''
                              ? Image.asset(
                                  'images/profile.png',
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                )
                              : Ink.image(
                                  image: NetworkImage(
                                      widget.user?.get('imageUrl')),
                                  fit: BoxFit.cover,
                                  width: 160,
                                  height: 160,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Chip(
                    label: Text(status,
                        style: TextStyle(color: Colors.black, fontSize: 16)),
                    backgroundColor: stateColor,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  UserName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontFamily: 'Comfortaa',
                      fontWeight: FontWeight.w500,
                      fontSize: 25),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  widget.user?.get('bio'),
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontFamily: 'Comfortaa',
                      fontSize: 16),
                ),
                SizedBox(
                  height: 40,
                ),
                Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    color: Colors.grey[100],
                    child: ListTile(
                      title: Center(
                          child: Text(
                        "  $UserName Events",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Comfortaa',
                            fontSize: 16),
                      )),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MyEvents()));
                      },
                    )),
                SizedBox(
                  height: 20,
                ),
              ]))
        ]));
  }
}







// class logout extends StatelessWidget {
//   const logout({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: ElevatedButton(
//         onPressed: () async {
//           await FirebaseAuth.instance.signOut();
//         },
//         child: Text('logout'),
//       ),
//     );
//   }
// }