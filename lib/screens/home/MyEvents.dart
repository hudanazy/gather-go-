import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:gather_go/Models/NewUser.dart';
import 'package:gather_go/screens/home/profile_form.dart';
import 'package:gather_go/screens/myAppBar.dart';
import 'MyEventsDetails.dart';

import 'package:gather_go/shared/loading.dart';
import 'package:provider/provider.dart';

// ignore: camel_case_types
class MyEvents extends StatefulWidget {
  @override
  _MyEvents createState() => _MyEvents();
}

// here i want to show all new event (not approved yet -> in DB approved = false)
// ignore: camel_case_types
class _MyEvents extends State<MyEvents> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<NewUser?>(context);
    Stream<QuerySnapshot<Map<String, dynamic>>> snap = FirebaseFirestore
        .instance
        .collection('events')
        .where('uid', isEqualTo: user!.uid)
        .snapshots();

    return Scaffold(
      appBar: SecondaryAppBar(title: "All My Events",),
        body: Container(
          child:
      //   Column(
      // children: [
        // AppBar(
        //   leading: IconButton(
        //     icon: new Icon(
        //       Icons.arrow_back_ios,
        //       color: Colors.black,
        //     ),
        //     onPressed: () {
        //       Navigator.pop(context,
        //           MaterialPageRoute(builder: (context) => ProfileForm()));
        //     },
        //   ),
        //   toolbarHeight: 100,
        //   backgroundColor: Colors.white,
        //   title: Text(
        //     "All My Events",
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
            //    height: 500,
              //  width: 400,
                child: ListView(
                  children: snapshot.data.docs.map<Widget>((document) {
                    DocumentSnapshot uid = document;
                    return Padding(
                        padding: const EdgeInsets.all(8),
                        child: Card(
                          elevation: 6,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side:
                                  BorderSide(width: 0.5, color: Colors.orange.shade400)),
                            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            //color: Colors.grey[200],
                            child: ListTile(
                              title: Center(
                                  child: Text(
                                document['name'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyEventsDetails(
                                              event: uid,
                                            )));
                              },
                            )));
                  }).toList(),
                ));
          },
        ),
     // ],
    ));
  }
}
