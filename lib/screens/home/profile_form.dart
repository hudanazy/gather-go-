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

class ProfileForm extends StatefulWidget {
  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>(); //for form

  String? _currentName;
  String? _currentBio;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    UesrInfo? profileData;
    final user = Provider.of<NewUser?>(context, listen: false);

    Stream<QuerySnapshot<Map<String, dynamic>>> snap = FirebaseFirestore
        .instance
        .collection('uesrInfo')
        .where('uid', isEqualTo: user?.uid)
        .snapshots();

    //  String userID = widget.profile?.get('uid');

    // String name = widget.profile?.get('name');
    // String status = widget.profile?.get('status');
    // String bio = widget.profile?.get('bio');
    void _showProfilePanel() {
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: epForm(),
            );
          });
    }

    //final AuthService _auth = AuthService();
    return StreamBuilder<Object>(
        stream: snap, //DatabaseService(uid: user.uid).profileData,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Loading(),
              //     child: Text(
              //   "No New Events", // may be change it to loading , itis appear for a second every time
              //   textAlign: TextAlign.center,
              // )
            );
          }
          return Container(
              height: 640,
              width: 500,
              child: ListView(
                children: snapshot.data.docs.map<Widget>((document) {
                  DocumentSnapshot uid = document;
                  String status = document['status'];
                  String state;
                  Color stateColor = Colors.grey;

                  if (status == "Available") {
                    state = "Available";
                    stateColor = Colors.lightGreen;
                  } else if (status == "Busy") {
                    state = "Disapprove";
                    stateColor = Colors.red;
                  } else if (status == true) {
                    state = 'At School';
                    stateColor = Colors.yellow;
                  } else if (status == true) {
                    state = 'At Work';
                    stateColor = Colors.yellow;
                  } else if (status == true) {
                    state = 'In a meeting';
                    stateColor = Colors.yellow;
                  } else if (status == true) {
                    state = 'Sleeping';
                    stateColor = Colors.lightGreen;
                  } else if (status == true) {
                    state = 'Away';
                    stateColor = Colors.grey;
                  }

                  return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 62),
                      child: Column(
                          // shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(10)),
                          // margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          // color: Colors.grey[200],
                          children: [
                            IconButton(
                              padding: EdgeInsets.only(left: 270, top: 40),
//alignment: Alignment.topRight,
                              // label: Text(
                              //   "Set event date",
                              //   style: TextStyle(
                              //     color: Colors.deepPurple,
                              //     fontSize: 20,
                              //     fontWeight: FontWeight.w500,
                              //   ),
                              // ),
                              onPressed: () async {
                                await FirebaseAuth.instance.signOut();
                              },
                              icon: Icon(
                                Icons.logout_outlined,
                                color: Colors.black,
                                size: 40,
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            ProfileWidget(
                              imagePath: "https://picsum.photos/200/300",
//document['name'],
                              isEdit: false,
                              onClicked: () async {
                                _showProfilePanel();
                              },
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Text(
                              document['name'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.grey[700],
                                  fontFamily: 'Comfortaa',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 25),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              document['status'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.orange[400],
                                  fontFamily: 'Comfortaa',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Text(
                              document['bio'],
                              style: TextStyle(
                                  color: Colors.grey[800],
                                  fontFamily: 'Comfortaa',
                                  fontSize: 18),
                            ),
                          ]));
                }).toList(),
              ));
        });
  }

  Widget buildName(UesrInfo? user) => Column(
        children: [
          Text(
            user?.name ?? 'Huda',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            user?.email ?? 'huda1@gmail.com',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ],
      );

  Widget buildAbout(UesrInfo? user) => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          children: [
            Text(
              "About ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              user?.bio ??
                  'I\'m a senior software engineering student at king Saud University. Our SWE group is currently developing this app.',
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout_outlined),
              label: Text('Log out'),
            ),
          ],
        ),
      );
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
