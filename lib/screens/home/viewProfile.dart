import 'package:flutter/material.dart';

import 'package:gather_go/screens/home/eventDetailsForUsers.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gather_go/screens/home/viewEventCreatorEvents.dart';
import 'package:gather_go/screens/myAppBar.dart';
import 'package:gather_go/shared/loading.dart';

import 'MyEvents.dart';

// ignore: camel_case_types
class viewProfile extends StatefulWidget {
  final DocumentSnapshot? user;
  final DocumentSnapshot? event;
  viewProfile({required this.user, required this.event});
  @override
  _viewProfile createState() => _viewProfile();
}

// ignore: camel_case_types
class _viewProfile extends State<viewProfile> {
//widget.user?.get('name')
  @override
  Widget build(BuildContext context) {
    //final color = Theme.of(context).colorScheme.primary;
    Stream<QuerySnapshot<Map<String, dynamic>>> snap = FirebaseFirestore
        .instance
        .collection('events')
        .where('uid', isEqualTo: widget.user?.get('uid'))
        .where('approved', isEqualTo: true)
        .snapshots();
    String status = widget.user?.get('status');
    String UserName = widget.user?.get('name');
    //DatabaseService(uid: user.uid).profileData,
    String state;
    Color stateColor = Colors.grey;
    if (status == "Available") {
      state = "Available";
      stateColor = Colors.lightGreen;
    } else if (status == "Busy") {
      state = "Disapprove";
      stateColor = Colors.red[200]!;
    } else if (status == 'At School') {
      state = 'At School';
      stateColor = Colors.yellow;
    } else if (status == 'At Work') {
      state = 'At Work';
      stateColor = Colors.yellow;
    } else if (status == 'In a meeting') {
      state = 'In a meeting';
      stateColor = Colors.orange[300]!;
    } else if (status == 'Sleeping') {
      state = 'Sleeping';
      stateColor = Colors.lightGreen;
    } else if (status == 'Away') {
      state = 'Away';
      stateColor = Colors.grey;
    }
    return Scaffold(
        appBar: SecondaryAppBar(
          title: 'Profile',
        ),
        body: Column(children: [
          // AppBar(
          //   leading: IconButton(
          //     icon: new Icon(
          //       Icons.arrow_back_ios,
          //       color: Colors.black,
          //     ),
          //     onPressed: () {
          //       Navigator.pop(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) =>
          //                   eventDetailsForUesers(event: widget.event)));
          //     },
          //   ),
          //  // toolbarHeight: 110,
          //   backgroundColor: Colors.white,
          //   // title: Text(
          //   //   "Profile",
          //   //   textAlign: TextAlign.center,
          //   //   style: TextStyle(
          //   //       color: Colors.black, fontFamily: 'Comfortaa', fontSize: 24),
          //   // ),
          // ),
          Container(
              height: 590,
              width: 500,
              child: ListView(children: [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 35),
                    child: Column(children: [
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: Stack(children: [
                          ClipOval(
                            child: Material(
                              color: Colors.transparent,
                              child: widget.user?.get('imageUrl') == ''
                                  ? Image.asset(
                                      'images/profile.png',
                                      width: 130,
                                      height: 130,
                                      fit: BoxFit.cover,
                                    )
                                  : Ink.image(
                                      image: NetworkImage(
                                          widget.user?.get('imageUrl')),
                                      fit: BoxFit.cover,
                                      width: 130,
                                      height: 130,
                                    ),
                            ),
                          ),
                        ]),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Chip(
                          label: Text(status,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16)),
                          backgroundColor: stateColor,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        UserName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontFamily: 'Comfortaa',
                            fontWeight: FontWeight.w500,
                            fontSize: 25),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        widget.user?.get('bio'),
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontFamily: 'Comfortaa',
                            fontSize: 16),
                      ),
                      SizedBox(
                        height: 23,
                      ),
                      StreamBuilder(
                        stream: snap,
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
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
                              height: 300,
                              width: 500,
                              child: ListView(
                                scrollDirection: Axis.vertical,
                                children:
                                    snapshot.data.docs.map<Widget>((document) {
                                  DocumentSnapshot uid = document;
                                  return Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: BorderSide(
                                                  width: 0.5,
                                                  color:
                                                      Colors.orange.shade400)),
                                          margin: const EdgeInsets.fromLTRB(
                                              10, 0, 10, 0),
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
                                              color: Colors.purple[300],
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          eventDetailsForUesers(
                                                            event: uid,
                                                          )));
                                            },
                                          )));
                                }).toList(),
                              ));
                        },
                      ),
                      // Card(
                      //     shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(10)),
                      //     margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      //     color: Colors.grey[100],
                      //     child: ListTile(
                      //       title: Center(
                      //           child: Text(
                      //         "  $UserName Events",
                      //         textAlign: TextAlign.center,
                      //         style: TextStyle(
                      //             color: Colors.black,
                      //             fontFamily: 'Comfortaa',
                      //             fontSize: 16),
                      //       )),
                      //       trailing: Icon(
                      //         Icons.arrow_forward_ios,
                      //       ),
                      //       onTap: () {
                      //         Navigator.of(context).push(MaterialPageRoute(
                      //             builder: (context) =>
                      //                 viewEventCreatorEvents(user: widget.user)));
                      //       },
                      //     )),
                      SizedBox(
                        height: 20,
                      ),
                    ]))
              ]))
        ]));
  }
}







// class logout extends StatelessWidget {
//   const logout({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: ElevatedButton(
//         onPressed: () async {
//           await FirebaseAuth.instance.signOut();
//         },
//         child: Text('logout'),
//       ),
//     );
//   }
// }