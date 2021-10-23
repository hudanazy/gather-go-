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
                  return Padding(
                      padding: const EdgeInsets.all(8),
                      child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          color: Colors.grey[200],
                          child: SizedBox(
                            height: 400,
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.purple[300],
                              ),
                              title: Center(
                                  child: Text(
                                document['name'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.deepOrange,
                                    fontFamily: 'Comfortaa',
                                    fontSize: 16),
                              )),
                              subtitle: Text(
                                document['bio'],
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    fontFamily: 'Comfortaa',
                                    fontSize: 14),
                              ),
                              trailing: Icon(
                                Icons.edit,
                              ),
                              onTap: () {
                                _showProfilePanel();
                              },
                            ),
                          )));
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
