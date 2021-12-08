//import 'dart:html';

//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gather_go/Models/NewUser.dart';

import 'package:gather_go/screens/home/eventDetailsForUsers.dart';
import 'package:gather_go/screens/myAppBar.dart';
import 'package:gather_go/shared/loading.dart';
import 'package:provider/provider.dart';
//import 'package:gather_go/shared/loading.dart';

///import 'package:gather_go/services/database.dart';
import 'package:gather_go/screens/comments/new_message.dart';
import "package:like_button/like_button.dart";

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
    final user = Provider.of<NewUser?>(context);
    // commenter(widget.user!.id);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Stream<QuerySnapshot<Map<String, dynamic>>> snapshot = FirebaseFirestore
        .instance
        .collection('comments')
        .orderBy("timePosted", descending: true)
        .where('eventID', isEqualTo: widget.event?.id)
        .snapshots();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: SecondaryAppBar(
        title: "Comments",
      ),
      body: Column(
        children: [
          // SizedBox(height: 5,),
          // SizedBox(
          //   height: 45,
          //   child: Text(
          //     widget.event?.get('name'),
          //     textAlign: TextAlign.center,
          //     style: TextStyle(
          //       fontWeight: FontWeight.bold,
          //       fontSize: 20,
          //       color: Colors.purple[600]),
          //   ),
          // ),
          Container(
              alignment: Alignment.center,
              child:
                  // color: Colors.white,
                  // child: Column(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // children: [
                  // SizedBox(
                  //   height: 40,
                  // ),
                  //   Row(children: [
                  // IconButton(
                  //   icon: new Icon(Icons.arrow_back_ios),
                  //   onPressed: () {
                  //     Navigator.pop(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => eventDetailsForUesers(
                  //                   event: widget.event,
                  //                 )));
                  //   },
                  // ),
                  // Flexible(
                  //   child: Text(widget.event?.get('name') + ' comments  ',
                  //       style: TextStyle(
                  //           color: Colors.deepOrange,
                  //           fontFamily: 'Comfortaa',
                  //           fontSize: 26)),
                  // ),
                  //   ]),
                  //   Column(
                  //   children: [
                  // Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  // SizedBox(height: 10),
                  StreamBuilder(
                      stream: snapshot,
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: Loading(),
                          );
                        }
                        if (snapshot.data.size == 0)
                          return Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Text(
                              "No comments yet.",
                              textAlign: TextAlign.center,
                            ),
                          );

                        return //Padding(

                            // child:
                            Container(
                          padding: EdgeInsets.only(
                            top: 10,
                          ), //right: 20
                          height: (height / 1.5) + 25,
                          width: width / 1.2,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              //reverse: true,
                              children:
                                  snapshot.data.docs.map<Widget>((document) {
                                DocumentSnapshot uid = document;
                                int likeCount = document['likes'];
                                List list = document['likeList'];
                                bool isLiked = false;
                                if (list.contains(user!.uid)) {
                                  isLiked = true;
                                }

                                final now = DateTime.now();
                                final past = document['timePosted'].toDate();

                                final differenceDays =
                                    now.difference(past).inDays;
                                final differenceHours =
                                    now.difference(past).inHours;
                                final differenceMinutes =
                                    now.difference(past).inMinutes;
                                final differenceSeconds =
                                    now.difference(past).inSeconds;
                                final differenceMS =
                                    now.difference(past).inMilliseconds;
                                String ago = "";

                                if (differenceDays == 0) {
                                  if (differenceHours == 0) {
                                    if (differenceMinutes == 0) {
                                      if (differenceSeconds == 0) {
                                        if (differenceMS == 0) {
                                          ago = "now";
                                        } else {
                                          ago = differenceMS.toString() + "ms";
                                        }
                                      } else {
                                        ago =
                                            differenceSeconds.toString() + "s";
                                      }
                                    } else {
                                      ago = differenceMinutes.toString() + "m";
                                    }
                                  } else {
                                    ago = differenceHours.toString() + "h";
                                  }
                                } else {
                                  var months;
                                  if (differenceDays > 30) {
                                    months = differenceDays / 30;
                                    ago = ((months).floor()).toString() + "mo";
                                    var year;
                                    if (months >= 12) {
                                      year = months / 12;
                                      ago = year.floor().toString() + "y";
                                    }
                                  } else {
                                    ago = differenceDays.toString() + "d";
                                  }
                                }
                                //to get commenters current profile image
                                // commenter(document['uid']);
                                return Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Center(
                                        child: Stack(
                                          children: [
                                            ClipOval(
                                              child: Material(
                                                color: Colors.transparent,
                                                child:
                                                    document['imageUrl'] == ""
                                                        ? Image.asset(
                                                            'images/profile.png',
                                                            width: 70,
                                                            height: 70,
                                                            fit: BoxFit.cover,
                                                          )
                                                        : Ink.image(
                                                            image: NetworkImage(
                                                                document[
                                                                    'imageUrl']),
                                                            fit: BoxFit.cover,
                                                            width: 60,
                                                            height: 60,
                                                          ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            top: 10, left: 20, right: 10),
                                        decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(.3),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              // Container(
                                              //   width: width / 1.5,
                                              //   child: Text(
                                              //       document['name']),
                                              // ),
                                              Container(
                                                width: width / 1.5,
                                                child: Text(
                                                  document['name'],
                                                  style: TextStyle(
                                                      color:
                                                          Colors.orange[700]),
                                                ),
                                              ),
                                              Container(
                                                width: width / 1.5,
                                                child: Text(document['text']),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(ago),
                                                  LikeButton(
                                                      size: 20,
                                                      isLiked: isLiked,
                                                      likeCount: likeCount,
                                                      countBuilder: (likeCount,
                                                          isLiked, text) {
                                                        return Text(
                                                          text,
                                                          style: TextStyle(
                                                            color: isLiked
                                                                ? Colors.black
                                                                : Colors.grey,
                                                          ),
                                                        );
                                                      },
                                                      onTap: (isLiked) async {
                                                        if (!isLiked) {
                                                          list.add(user.uid);
                                                          likeCount++;
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "comments")
                                                              .doc(uid.id)
                                                              .update({
                                                            "likeList": list,
                                                            "likes": likeCount,
                                                          });
                                                          isLiked = true;
                                                          return true;
                                                        }
                                                        if (isLiked) {
                                                          list.remove(user.uid);
                                                          likeCount--;
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "comments")
                                                              .doc(uid.id)
                                                              .update({
                                                            "likeList": list,
                                                            "likes": likeCount,
                                                          });
                                                          isLiked = false;
                                                          return false;
                                                        }
                                                      }),
                                                  IconButton(
                                                    onPressed: () async {},
                                                    icon: Icon(Icons.report),
                                                    color: Colors.grey,
                                                    iconSize: 20,
                                                  ),
                                                ],
                                              ),
                                            ]),
                                      ),
                                    ),
                                  ]),
                                );
                                //       },
                                //     )));
                              }).toList(), //docmnt
                            ),
                          ),
                          //  ),
                        );
                      })
              //   ]
              //),
              //],
              // ),
              // ],
              //   ),
              ),
        ],
      ),
      bottomSheet: NewMessage(
        event: widget.event,
        user: widget.user,
      ),
    );
  }

  String name = "";
  String imageUrl = "";
  late DocumentSnapshot? documentList;
  // will return eventCreator name
  void commenter(String uid) async {
    String Name = "";
    String image = "";
    documentList =
        await FirebaseFirestore.instance.collection('uesrInfo').doc(uid).get();

    Name = documentList?['name'];
    image = documentList?['imageUrl'];

    setState(() {
      name = Name;
      imageUrl = image;
    });
  }
}
