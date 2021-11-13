import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gather_go/shared/loading.dart';

import 'eventDetailsForUsers.dart';

class search extends StatefulWidget {
  const search({ Key? key }) : super(key: key);

  @override
  _searchState createState() => _searchState();
}

class _searchState extends State<search> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot<Map<String, dynamic>>> snap = FirebaseFirestore.instance.collection('events')
    .where('searchDescription', arrayContains: 'it').snapshots();
    
    return StreamBuilder<Object>(
      stream: snap,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
        if (snapshot.data.size == 0){
        return Center(
          child: Text('No events'),
        );}
        return Scaffold(
          body: ListView(
            children: snapshot.data.docs
                                        .map<Widget>((document) {
                                      DocumentSnapshot uid = document;
                                      return Padding(
                                          padding: const EdgeInsets.all(8),
                                          //  const EdgeInsets.only(right: 70),
                                          child: Card(
                                              elevation: 6,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  side: BorderSide(
                                                      width: 0.5,
                                                      color: Colors.amber)),
                                              margin: const EdgeInsets.fromLTRB(
                                                  10, 0, 10, 0),
                                              //color: Colors.orangeAccent,
                                              child: ListTile(
                                                title: Center(
                                                    child: Text(
                                                  document['name'],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.amber[600],
                                                      fontFamily: 'Comfortaa',
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                                /*  subtitle: Text(
                                                  document['date'].toString(),
                                                  style: TextStyle(
                                                      color: Colors.amber[600],
                                                      fontFamily: 'Comfortaa',
                                                      fontSize: 14),
                                                ), */
                                                // 00:000
                                                trailing: Icon(
                                                  Icons.arrow_forward_ios_sharp,
                                                  color: Colors.purple[300],
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              eventDetailsForUesers(
                                                                event: uid,
                                                                // change to move to details and booked
                                                              )));
                                                },
                                              )));
                                    }).toList(), //docmnt
          ),
        );
      }
    );
    
  }
}