//import 'dart:html';

//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gather_go/Models/NewUser.dart';

import 'package:gather_go/screens/home/eventDetailsForUsers.dart';
import 'package:provider/provider.dart';
//import 'package:gather_go/shared/loading.dart';

///import 'package:gather_go/services/database.dart';
import 'package:gather_go/screens/comments/new_message.dart';

class CommentScreen extends StatefulWidget {
  // const CommentScreen({Key? key}) : super(key: key);
  final DocumentSnapshot? user;
  final DocumentSnapshot? event;
  CommentScreen({required this.event, required this.user});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    Stream<QuerySnapshot<Map<String, dynamic>>> snapshot = FirebaseFirestore
        .instance
        .collection('comments')
        .orderBy("timePosted", descending: true)
        .where('eventID', isEqualTo: widget.event?.id)
        .snapshots();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            //height: 200,
            // width: 400,
            // padding: EdgeInsets.all(20),
            color: Colors.white,

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
                // Padding(
                //     padding: const EdgeInsets.all(30),
                // padding: const EdgeInsets.only(left: 30),
                // child:
                Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(height: 350),
                          StreamBuilder(
                              stream: snapshot,
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: Text("No comments yet."),
                                  );
                                }

                                return Padding(
                                  padding: EdgeInsets.only(top: 10, right: 20),
                                  child: Container(
                                    height: 350,
                                    width: 280,
                                    child: Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        //reverse: true,
                                        children: snapshot.data.docs
                                            .map<Widget>((document) {
                                          DocumentSnapshot uid = document;
                                          return Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  top: 10, left: 10, right: 10),
                                              decoration: BoxDecoration(
                                                  color: Colors.grey
                                                      .withOpacity(.3),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  // padding: const EdgeInsets.all(8),
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Center(
                                                          child: Stack(
                                                            children: [
                                                              ClipOval(
                                                                child: Material(
                                                                  color: Colors
                                                                      .transparent,
                                                                  child: widget.user?.get(
                                                                              'imageUrl') ==
                                                                          ''
                                                                      ? Image
                                                                          .asset(
                                                                          'images/profile.png',
                                                                          width:
                                                                              70,
                                                                          height:
                                                                              70,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        )
                                                                      : Ink
                                                                          .image(
                                                                          image: NetworkImage(widget
                                                                              .user
                                                                              ?.get('imageUrl')),
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          width:
                                                                              160,
                                                                          height:
                                                                              160,
                                                                        ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Container(
                                                      width: width / 1.5,
                                                      child: Text(
                                                          document['text']),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        IconButton(
                                                          onPressed:
                                                              () async {},
                                                          icon: Icon(Icons
                                                              .thumb_up_alt_rounded),
                                                          color: Colors.grey,
                                                          iconSize: 20,
                                                        ),
                                                        Text('0'),
                                                        IconButton(
                                                          onPressed:
                                                              () async {},
                                                          icon: Icon(Icons
                                                              .thumb_down_alt_rounded),
                                                          color: Colors.grey,
                                                          iconSize: 20,
                                                        ),
                                                        Text('0'),
                                                        IconButton(
                                                          onPressed:
                                                              () async {},
                                                          icon: Icon(
                                                              Icons.report),
                                                          color: Colors.grey,
                                                          iconSize: 20,
                                                        ),
                                                      ],
                                                      //  const EdgeInsets.only(right: 70),
                                                      // child: Card(
                                                      //     elevation: 6,
                                                      //     shape: RoundedRectangleBorder(
                                                      //         borderRadius:
                                                      //             BorderRadius.circular(
                                                      //                 10),
                                                      //         side: BorderSide(
                                                      //             width: 0.5,
                                                      //             color: Colors.amber)),
                                                      //     margin:
                                                      //         const EdgeInsets.fromLTRB(
                                                      //             10, 0, 10, 0),
                                                      //     //color: Colors.orangeAccent,
                                                      //     child: ListTile(
                                                      //       title: Center(
                                                      //           child: Text(
                                                      //         document['text'],
                                                      //         textAlign:
                                                      //             TextAlign.center,
                                                      //         style: TextStyle(
                                                      //             color:
                                                      //                 Colors.amber[600],
                                                      //             fontFamily:
                                                      //                 'Comfortaa',
                                                      //             fontSize: 16,
                                                      //             fontWeight:
                                                      //                 FontWeight.bold),
                                                      //       )),
                                                      //       /*  subtitle: Text(
                                                      //           document['date'].toString(),
                                                      //           style: TextStyle(
                                                      //               color: Colors.amber[600],
                                                      //               fontFamily: 'Comfortaa',
                                                      //               fontSize: 14),
                                                      //         ), */
                                                      //       // 00:000
                                                      //       trailing: Icon(
                                                      //         Icons
                                                      //             .arrow_forward_ios_sharp,
                                                      //         color: Colors.purple[300],
                                                      //       ),
                                                      //       onTap: () {
                                                      //         // Navigator.push(
                                                      //         //     context,
                                                      //         //     MaterialPageRoute(
                                                      //         //         builder: (context) =>
                                                      //         //             eventDetailsForUesers(
                                                      //         //               event: uid,
                                                      //         //               // change to move to details and booked
                                                      //         //             ))
                                                    ),
                                                  ]),
                                            ),
                                          );
                                          //       },
                                          //     )));
                                        }).toList(), //docmnt
                                      ),
                                    ),
                                  ),
                                );
                              })
                        ]),
                  ],
                )
                // )
              ],
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
