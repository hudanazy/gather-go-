//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gather_go/screens/home/eventDetailsForUsers.dart';
import 'package:gather_go/services/database.dart';

class CommentScreen extends StatefulWidget {
  // const CommentScreen({Key? key}) : super(key: key);
  final DocumentSnapshot? event;
  CommentScreen({required this.event});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40),
            ),
            Row(children: [
              IconButton(
                icon: new Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(
                      context,
                      MaterialPageRoute(
                          builder: (context) => eventDetailsForUesers(
                                event: widget.event,
                              )));
                },
              ),
              Flexible(
                child: Text(widget.event?.get('name') + '   ',
                    style: TextStyle(
                        color: Colors.deepOrange,
                        fontFamily: 'Comfortaa',
                        fontSize: 18)),
              ),
            ]),
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (ctx, index) => Container(
                padding: EdgeInsets.all(8),
                child: Text("this works"),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            FirebaseFirestore.instance
                .collection('events/0opY97ALXRrj7UOg482R /messages')
                .snapshots()
                .listen((data) {
              print(data);
            });
          }),
    );
  }
}
