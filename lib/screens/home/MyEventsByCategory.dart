import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:gather_go/Models/NewUser.dart';
import 'package:gather_go/screens/home/profile_form.dart';
import 'package:gather_go/screens/myAppBar.dart';
import 'MyEventsDetails.dart';

import 'package:gather_go/shared/loading.dart';
import 'package:provider/provider.dart';

import 'eventDetailsForUsers.dart';

// ignore: camel_case_types
class MyEventsByCategory extends StatefulWidget {
  final String? category;
  MyEventsByCategory({required this.category});
  @override
  _MyEventsByCategory createState() => _MyEventsByCategory(category);
}

// here i want to show all new event (not approved yet -> in DB approved = false)
// ignore: camel_case_types
class _MyEventsByCategory extends State<MyEventsByCategory> {
  final String? category;
  _MyEventsByCategory(this.category);
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<NewUser?>(context);
    String uuuu = FirebaseAuth.instance.currentUser!.uid;
    Stream<QuerySnapshot<Map<String, dynamic>>> snap = FirebaseFirestore
        .instance
        .collection('events')
        .where('category', isEqualTo: category)
        .where('approved', isEqualTo: true)
        .snapshots();

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: SecondaryAppBar(
          title: "All $category Events",
        ),
        body: Container(
          child:
              //   Column(
              // children: [
              // AppBar(
              //   // leading: IconButton(
              //   //   icon: new Icon(
              //   //     Icons.arrow_back_ios,
              //   //     color: Colors.black,
              //   //   ),
              //   //   onPressed: () {
              //   //     Navigator.pop(context,
              //   //         MaterialPageRoute(builder: (context) => ProfileForm()));
              //   //   },
              //   // ),
              //   toolbarHeight: 100,
              //   backgroundColor: Colors.white,
              //   title: Text(
              //     "All $category Events",
              //     textAlign: TextAlign.center,
              //     style: TextStyle(
              //         color: Colors.black, fontFamily: 'Comfortaa', fontSize: 24),
              //   ),
              // ),
              StreamBuilder(
            stream: snap,
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
                  padding: const EdgeInsets.only(top: 10),
                  //  height: 500,
                  // width: 400,
                  child: ListView(
                    children: snapshot.data.docs.map<Widget>((document) {
                      DocumentSnapshot uid = document;
                      return Padding(
                          padding: const EdgeInsets.all(8),
                          child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                      width: 0.5,
                                      color: Colors.orange.shade400)),
                              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              //color: Colors.grey[200],
                              child: ListTile(
                                title: Center(
                                    child: Text(
                                  document['name'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.grey[800],
                                      fontFamily: 'Comfortaa',
                                      fontSize: 16),
                                )),
                                // subtitle: Text(
                                //   document['description'],
                                //   style: TextStyle(
                                //       color: Colors.grey[800],
                                //       fontFamily: 'Comfortaa',
                                //       fontSize: 14),
                                // ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.orange[300],
                                ),
                                onTap: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             eventDetailsForUesers(
                                  //               event: uid,
                                  //               // change to move to details and booked
                                  //             )));
                                  if (document['uid'] == uuuu) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MyEventsDetails(
                                                  event: uid,
                                                )));
                                  } else
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                eventDetailsForUesers(
                                                  event: uid,
                                                )));
                                },
                              )));
                    }).toList(),
                  ));
            },
          ),
          //  ],
        ));
  }
}
