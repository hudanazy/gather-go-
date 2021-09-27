import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gather_go/screens/admin/eventDetails.dart';

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
            )),
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('events')
              .where('approved', isEqualTo: false)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child: Text(
                "No New Events",
                textAlign: TextAlign.center,
              ));
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
                                Icons.arrow_forward,
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
