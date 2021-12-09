import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:gather_go/screens/home/BookedEvents.dart';
import 'package:gather_go/screens/home/edit_profile_form.dart';
import 'package:gather_go/screens/myAppBar.dart';
import 'package:gather_go/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:gather_go/Models/NewUser.dart';
import 'package:gather_go/Models/UesrInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'MyEvents.dart';

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
    return Scaffold(
        backgroundColor: Colors.white10,
        appBar: MyAppBar(
          title: '\tProfile',
        ),
        body: StreamBuilder<Object>(
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
                  //  height: 640,
                  // width: 500,
                  color: Colors.white10,
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

                      return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 52),
                          child: Column(
                              // shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(10)),
                              // margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              // color: Colors.grey[200],
                              children: [
                                // IconButton(
                                //   iconSize: 45,
                                //   padding: EdgeInsets.only(left: 270, top: 40),
                                //   icon: Icon(
                                //     Icons.logout_outlined,
                                //     color: Colors.black,
                                //   ),
//alignment: Alignment.topRight,
                                // label: Text(
                                //   "Set event date",
                                //   style: TextStyle(
                                //     color: Colors.deepPurple,
                                //     fontSize: 20,
                                //     fontWeight: FontWeight.w500,
                                //   ),
                                // ),
                                //   onPressed: () async {
                                //     await FirebaseAuth.instance.signOut();
                                //   },
                                // ),
                                SizedBox(
                                  height: 25,
                                ),
                                Center(
                                  child: Stack(
                                    children: [
                                      ClipOval(
                                        child: Material(
                                          color: Colors.transparent,
                                          child: document['imageUrl'] == ''
                                              ? Image.asset(
                                                  'images/profile.png',
                                                  width: 200,
                                                  height: 200,
                                                  fit: BoxFit.cover,
                                                )
                                              : Ink.image(
                                                  image: NetworkImage(
                                                      document['imageUrl']),
                                                  fit: BoxFit.cover,
                                                  width: 160,
                                                  height: 160,
                                                ),
                                        ),
                                      ),
                                      document['imageUrl'] == ''
                                          ? Positioned(
                                              bottom: 15,
                                              right: 15,
                                              child: buildEditIcon(Colors.blue))
                                          :
                                          // child: document['imageUrl'] ??
                                          // Image.asset(
                                          //   'images/profile.png',
                                          //   width: 200,
                                          //   height: 200,
                                          //   fit: BoxFit.cover,
                                          // )),
                                          Positioned(
                                              bottom: 0,
                                              right: 4,
                                              child: buildEditIcon(Colors.blue))
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
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16)),
                                    backgroundColor: stateColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  document['name'],
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

                                // Text(
                                //   document['status'],
                                //   textAlign: TextAlign.center,
                                //   style: TextStyle(
                                //       color: Colors.orange[300],
                                //       fontFamily: 'Comfortaa',
                                //       fontWeight: FontWeight.w600,
                                //       fontSize: 15),
                                // ),

                                Text(
                                  document['bio'],
                                  style: TextStyle(
                                      color: Colors.grey[800],
                                      fontFamily: 'Comfortaa',
                                      fontSize: 16),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Card(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                            width: 0.5,
                                            color: Colors.orange.shade400)),
                                    margin:
                                        const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    //color: Colors.grey[100],
                                    child: ListTile(
                                      title: Center(
                                          child: Text(
                                        "Created Events",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.grey[800],
                                          fontFamily: 'Comfortaa',
                                          fontSize: 16,
                                        ),
                                      )),
                                      trailing: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.orange[300],
                                      ),
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyEvents()));
                                      },
                                    )),
                                SizedBox(
                                  height: 20,
                                ),
                                Card(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                            width: 0.5,
                                            color: Colors.orange.shade400)),
                                    margin:
                                        const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    //color: Colors.grey[100],
                                    child: ListTile(
                                      title: Center(
                                          child: Text(
                                        "Booked Events",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.grey[800],
                                          fontFamily: 'Comfortaa',
                                          fontSize: 16,
                                          //      fontWeight: FontWeight.bold
                                        ),
                                      )),
                                      trailing: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.orange[300],
                                      ),
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BookedEvents()));
                                      },
                                    ))
                              ]));
                    }).toList(),
                  ));
            }));
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

  Widget buildEditIcon(Color color) => InkWell(
      onTap: () async {
        //imagePicker();
        showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return Container(
                //padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
                child: epForm(),
              );
            });
      },
      child: buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: Icon(
            Icons.edit,
            color: Colors.white,
            size: 25,
          ),
        ),
      ));
  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
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