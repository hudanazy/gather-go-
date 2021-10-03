import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gather_go/screens/admin/adminNav.dart';
import 'package:gather_go/screens/admin/eventDetails.dart';

import 'package:flutter/material.dart';
import 'package:gather_go/shared/loading.dart';

// ignore: camel_case_types
class adminEvent extends StatefulWidget {
  @override
  _adminEvent createState() => _adminEvent();
}

// here i want to show all new event (not approved yet -> in DB approved = false)
// ignore: camel_case_types
class _adminEvent extends State<adminEvent> {
  Stream<QuerySnapshot<Map<String, dynamic>>> snap = FirebaseFirestore.instance
      .collection('events')
      .orderBy("timePosted")
      .where('approved', isEqualTo: false)
      .where('adminCheck', isEqualTo: false)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        AppBar(
            backgroundColor: Colors.white,
            title: Text(
              "All New Events",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.deepOrange,
                  fontFamily: 'Comfortaa',
                  fontSize: 18),
            ),
            actions: [
              Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
                ElevatedButton.icon(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                    },
                    icon: Icon(Icons.logout, color: Colors.deepOrange),
                    label: Text('Log Out',
                        style: TextStyle(
                          color: Colors.deepOrange,
                        )),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                    )),
              ])
            ]),
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
                height: 550,
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
                            child: ListTile(
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
                                document['description'],
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    fontFamily: 'Comfortaa',
                                    fontSize: 14),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => eventDetails(
                                              event: uid,
                                            )));
                              },
                            )));
                  }).toList(),
                ));
          },
        ),
      ],
    ));
  }
}