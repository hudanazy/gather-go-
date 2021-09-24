import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gather_go/screens/home/EventTile.dart';

import 'package:provider/provider.dart';

import 'package:gather_go/Models/EventInfo.dart';

// ignore: camel_case_types
class adminEvent extends StatefulWidget {
  @override
  _adminEvent createState() => _adminEvent();
}

// here i want to show all new event (not approved yet -> in DB approved = false)
// ignore: camel_case_types
class _adminEvent extends State<adminEvent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return Text("No new events");
          }
          return ListView(
            children: snapshot.data.docs.map<Widget>((document) {
              return Padding(
                  padding: EdgeInsets.only(top: (8.0)),
                  child: Card(
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      color: Colors.deepPurple[50],
                      child: ListTile(
                        title: Text(document['name']),
                        subtitle: Text(document['description']),
                      )));
            }).toList(),
          );
        },
      ),
    );
  }
}
