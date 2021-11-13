//import 'dart:html';

//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gather_go/Models/NewUser.dart';

import 'package:gather_go/screens/home/eventDetailsForUsers.dart';
import 'package:provider/provider.dart';
import 'package:gather_go/shared/loading.dart';

///import 'package:gather_go/services/database.dart';
import 'package:gather_go/screens/comments/new_message.dart';

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
    final user = Provider.of<NewUser?>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Container(
            //height: 200,
            // width: 400,
            // padding: EdgeInsets.all(20),
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                      child: Text(widget.event?.get('name') + ' comments  ',
                          style: TextStyle(
                              color: Colors.deepOrange,
                              fontFamily: 'Comfortaa',
                              fontSize: 18)),
                    ),
                  ]),
                  Padding(
                      padding: const EdgeInsets.all(30),
                      // padding: const EdgeInsets.only(left: 30),
                      child: Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(height: 350),
                                StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('comments')
                                        .orderBy("timePosted")
                                        .where('eventID',
                                            isEqualTo: widget.event?.id)
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<dynamic> snapshot) {
                                      if (!snapshot.hasData) {
                                        return Center(
                                          child: Text("No comments yet."),
                                        );
                                      }

                                      return Container(
                                        height: 350,
                                        width: 280,
                                        child: ListView(
                                          children: snapshot.data.docs
                                              .map<Widget>((document) {
                                            DocumentSnapshot uid = document;
                                            return Padding(
                                                padding: const EdgeInsets.all(
                                                    8),
                                                //  const EdgeInsets.only(right: 70),
                                                child: Card(
                                                    elevation: 6,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            side: BorderSide(
                                                                width: 0.5,
                                                                color: Colors
                                                                    .amber)),
                                                    margin: const EdgeInsets
                                                        .fromLTRB(10, 0, 10, 0),
                                                    //color: Colors.orangeAccent,
                                                    child: ListTile(
                                                      title: Center(
                                                          child: Text(
                                                        document['text'],
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors
                                                                .amber[600],
                                                            fontFamily:
                                                                'Comfortaa',
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
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
                                                        Icons
                                                            .arrow_forward_ios_sharp,
                                                        color:
                                                            Colors.purple[300],
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
                                                      },
                                                    )));
                                          }).toList(), //docmnt
                                        ),
                                      );
                                    })
                              ]),
                        ],
                      ))
                ],
              ),
            ),
          ),
          // Expanded(
          //   child: Align(
          //     alignment: FractionalOffset.bottomCenter,
          //     child: NewMessage(
          //       event: widget.event,
          //     ),
          //   ),
          // )
        ],
      ),
      bottomNavigationBar: NewMessage(
        event: widget.event,
      ),
    );
  }
}
