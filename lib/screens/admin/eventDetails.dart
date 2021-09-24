import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class eventDetails extends StatefulWidget {
  final DocumentSnapshot? event;
  eventDetails({required this.event});

  @override
  _eventDetails createState() => new _eventDetails();
}

// ignore: camel_case_types
class _eventDetails extends State<eventDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(widget.event?.get('name'),
              style: TextStyle(
                  color: Colors.deepOrange,
                  fontFamily: 'Comfortaa',
                  fontSize: 18)),
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 500.0,
                child: Text(widget.event?.get('description'),
                    style: TextStyle(
                        color: Colors.deepPurple,
                        fontFamily: 'Comfortaa',
                        fontSize: 14)),
              )
            ]));
  }
}
