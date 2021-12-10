import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gather_go/screens/admin/adminEvent.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gather_go/screens/admin/eventdetailsLogo.dart';
import 'package:gather_go/screens/comment_screen.dart';
import 'package:gather_go/screens/home/Brows.dart';
import 'package:gather_go/screens/home/home.dart';
import 'package:gather_go/screens/home/viewProfile.dart';
import 'package:gather_go/screens/myAppBar.dart';
import 'package:gather_go/shared/dialogs.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gather_go/screens/home/MyEvents.dart';
import 'package:gather_go/screens/home/EditEventForm.dart';

import '../NotifactionManager.dart';

// ignore: camel_case_types
class MyEventsDetails extends StatefulWidget {
  final DocumentSnapshot? event;
  MyEventsDetails({required this.event});

  @override
  _MyEventsDetails createState() => new _MyEventsDetails();
}

// ignore: camel_case_types
class _MyEventsDetails extends State<MyEventsDetails> {
  double rating = 0;
  bool ratedBefore = false;
  int ratingCounter = 0;
  int arrayLength = 0;
  double ratingAVG = 0;
  bool rated = false;
  // LocationData? currentLocation;
  // var location = new Location();
  // String error = "";

  // void initState() {
  //   super.initState();

  //   initPlatformState();

  //   location.onLocationChanged.listen((LocationData result) {
  //     setState(() {
  //       currentLocation = result;
  //     });
  //   });
  // }

  // void initPlatformState() async {
  //   LocationData? myLocation;
  //   try {
  //     myLocation = await location.getLocation();
  //     error = "";
  //   } on PlatformException catch (e) {
  //     if (e.code == 'PERMISSION_DENIED')
  //       error = "permission denied";
  //     else if (e.code == "PERMISSION_DENIED_NEVER_ASK")
  //       error = "permission denied";
  //     myLocation = null;
  //   }

  //   setState(() {
  //     currentLocation = myLocation!;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot<Map<String, dynamic>>> commentSnap =
        FirebaseFirestore.instance
            .collection('comments')
            // .orderBy("timePosted")
            .where('eventID', isEqualTo: widget.event?.id)
            .snapshots();
    // var curLat = currentLocation?.latitude ?? 0;
    // var curLong = currentLocation?.longitude ?? 0;
    int attendeeNum = widget.event?.get('attendees');
    int bookedNum = widget.event!.get('bookedNumber');
    String userID = widget.event?.get('uid');
    String category = widget.event?.get('category');
    var eventDate = widget.event?.get("browseDate");
    double RatingNum = widget.event!.get('rating');
    bool ratedis = widget.event!.get('rated');
    double theRatingNumber = widget.event?.get('RatingNumber');
    int Count = (theRatingNumber - 1).floor();
    List listRating = widget.event?.get('RatingList');
    // final snap = FirebaseFirestore.instance
    // .collection('uesrInfo').doc(userID).collection('bookedEvents').where('uid', isEqualTo: widget.event!.id).snapshots();
    final buttonColor;
    List list = widget.event?.get('attendeesList');
    final currentUser = FirebaseAuth.instance.currentUser!.uid;

    List<Marker> myMarker = [];
    eventCreator(userID);
    LatLng markerPosition = LatLng(widget.event?.get('lat'),
        widget.event?.get('long')); // event location from DB

    setState(() {
      myMarker.add(Marker(
        markerId: MarkerId(markerPosition.toString()),
        infoWindow:
            InfoWindow(title: widget.event?.get('name')), // event name from DB
        position: markerPosition,
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
    eventCreator(userID);
    //String eventUID = widget.event?.uid;

    bool adminCheck = widget.event?.get('adminCheck');
    bool approved = widget.event?.get('approved');
    String state = "";
    Color stateColor = Colors.grey;

    if (adminCheck == false) {
      state = "Waiting";
      stateColor = Colors.grey;
    } else if (adminCheck == true && approved == false) {
      state = "Disapproved";
      stateColor = Colors.red;
    } else if (adminCheck == true && approved == true) {
      state = "Approved";
      stateColor = Colors.lightGreen;
    }
    return StreamBuilder<QuerySnapshot>(
        stream: commentSnap, //DatabaseService(uid: user.uid).profileData,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          //final data = snapshot.data.docs;
          var nComments;
          if (!snapshot.hasData) {
            nComments = "0";
          } else {
            nComments = snapshot.data.docs.length.toString();
          }
          return Scaffold(
            appBar: SecondaryAppBar(
              title: 'Event Details',
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // Padding(
                  //padding: const EdgeInsets.only(bottom: 10.0),
                  ClipPath(
                    child: Stack(children: [
                      widget.event?.get('imageUrl') != ''
                          ? Ink.image(
                              image: NetworkImage(
                                widget.event?.get('imageUrl'),
                              ),
                              height: 230,
                              width: 400,
                              fit: BoxFit.cover,
                              //width: 160,
                            )
                          : Image.asset(
                              'images/evv.jpg',
                              //   width: 200,
                              height: 230,
                              width: 400,
                              fit: BoxFit.cover,
                            ),
                      // IconButton(
                      //   color: widget.event?.get('imageUrl') != ''
                      //       ? Colors.white
                      //       : Colors.black,
                      //   icon: new Icon(Icons.arrow_back_ios),
                      //   iconSize: 30,
                      //   onPressed: () {
                      //     Navigator.pop(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => HomeScreen()));
                      //   },
                      // ),
                    ]),

                    // Image.asset(
                    //   'images/logo1.png',
                    //   width: 400,
                    //   height: 230.0,
                    //   fit: BoxFit.cover,
                    // ),
                  ),
                  Row(children: [
                    // IconButton(
                    //   icon: new Icon(Icons.arrow_back_ios),
                    //   onPressed: () {
                    //     Navigator.pop(context,
                    //         MaterialPageRoute(builder: (context) => adminEvent()));
                    //   },
                    // ),
                    Flexible(
                        child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(widget.event?.get('name') + '   ',
                          style: TextStyle(
                              color: Colors.orange[300],
                              fontFamily: 'Comfortaa',
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    )),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Chip(
                        label: Text(category,
                            style: TextStyle(color: Colors.black)),
                        backgroundColor: Colors.grey[350],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Chip(
                        label:
                            Text(state, style: TextStyle(color: Colors.black)),
                        backgroundColor: stateColor,
                      ),
                    )
                  ]),
                  Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: <Widget>[
                          if (theRatingNumber > 0)
                            RatingBar.builder(
                              itemSize: 15,
                              initialRating: RatingNum,
                              glow: true,
                              ignoreGestures: true,
                              minRating: 1,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (value) {},
                            ),
                          if (theRatingNumber > 0)
                            InkWell(
                              child: Text(
                                '($Count)',
                                style: TextStyle(fontSize: 10),
                              ),
                            )
                        ],
                      )),

//--------------

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Edescription(widget.event?.get('description')),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.access_time),
                        Flexible(
                          child: Text("   " +
                              widget.event?.get('date').substring(0, 10) +
                              "  " +
                              widget.event?.get('time').substring(10, 15) +
                              '                                                           '), // we may need to change it as i dont think this the right time !!
                        ) // we may need to change it as i dont think this the right time !!
                      ],
                    ),
                  ),
                  //   Padding(padding: const EdgeInsets.only(left: 20.0),
                  //  child: Row(children: <Widget>[
                  //     Text("        ")])),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Row(children: <Widget>[
                      Icon(Icons.people_alt_rounded),
                      Text("   Max attendee number is $attendeeNum  ")
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                    child: Row(children: <Widget>[
                      Icon(
                        Icons.person_rounded,
                      ),
                      Text("   Created by $_textFromFile (you) "),
                      // ElevatedButton(
                      //   child: Text(" $_textFromFile ",
                      //       style: TextStyle(
                      //         color: Colors.orange[300],
                      //         fontFamily: 'Comfortaa',
                      //         fontWeight: FontWeight.bold,
                      //       )),
                      //   style: ElevatedButton.styleFrom(
                      //     primary: Colors.white,
                      //   ),
                      //   //color: Colors.deepOrange,
                      //   onPressed: () {
                      //     // ProfileForm();
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => viewProfile(
                      //                   user: documentList,
                      //                 )));
                      //   },
                      //   //child: Text("see the location"),
                      // )
                    ]),
                  ),

                  // decoration: new BoxDecoration(
                  //   color: Colors.black,
                  //   shape: BoxShape.circle,
                  //   border: Border.all(width: 5.0, color: Colors.white),
                  // ),
                  Padding(
                      padding: const EdgeInsets.only(right: 20.0, bottom: 20.0),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            icon: Icon(
                              Icons.location_pin,
                              color: Colors.black,
                            ),
                            label: Text("see the location",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Comfortaa',
                                )),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                            ),
                            //color: Colors.deepOrange,
                            onPressed: () {
                              showMapdialogAdmin(
                                  context, myMarker, markerPosition);
                            },
                            //child: Text("see the location"),
                          ),
                        ],
                      )),
                  Padding(
                      padding: const EdgeInsets.only(right: 20.0, bottom: 20.0),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            icon: Icon(
                              Icons.message,
                              color: Colors.black,
                            ),
                            label: Text(nComments + " comments",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Comfortaa',
                                )),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                            ),
                            //color: Colors.deepOrange,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CommentScreen(
                                          user: documentList,
                                          event: widget.event)));
                            },
                            //child: Text("see the location"),
                          ),
                        ],
                      )),
                  //
                  Row(
                    children: [
                      Expanded(
                          child: Align(
                              alignment: Alignment.bottomCenter, //her
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.orange[300]),
                                  ),
                                  child: Text('Delete Event',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Comfortaa',
                                          fontSize: 12)),
                                  onPressed: () async {
                                    var result =
                                        await showDdeleteDialog(context);
                                    if (result == true) {
                                      try {
                                        FirebaseFirestore.instance
                                            .collection('events')
                                            .doc(widget.event?.id)
                                            .delete();

                                        var collection;
                                        var documentList;
                                        // will return eventCreator name

                                        collection = await FirebaseFirestore
                                            .instance
                                            .collection('comments')
                                            .where('eventID',
                                                isEqualTo: widget.event?.id);
                                        documentList = await collection.get();

                                        for (var doc in documentList.docs) {
                                          await doc.reference.delete();
                                        }

                                        Fluttertoast.showToast(
                                          msg: widget.event?.get('name') +
                                              " delete successfully",
                                          toastLength: Toast.LENGTH_LONG,
                                        );
                                        Navigator.pop(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyEvents()));
                                      } catch (e) {
                                        Fluttertoast.showToast(
                                          msg: "somthing went wrong ",
                                          toastLength: Toast.LENGTH_SHORT,
                                        );
                                      }
                                    }
                                  }))),
                      Expanded(
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.orange[300]),
                                  ),
                                  child: Text('Edit Event',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Comfortaa',
                                          fontSize: 12)),
                                  onPressed: () async {
                                    if (approved == true) {
                                      await showEditEventApproved(context);
                                    }
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EidtEventForm(
                                                event: widget.event)));
                                  })))
                    ],
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          );
        });
  }

  // Location _location = Location();
  // late GoogleMapController _controller;
  // void _onMapCreated(GoogleMapController _cntlr) {
  //   _controller = _cntlr;
  // }
  eventBookedDialog() {
    AlertDialog alert = AlertDialog(
      title: Text(
        'Event booked',
        style: TextStyle(
          color: Colors.red,
        ),
      ),
      content: Text(
        'You already booked this event.',
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      actions: [
        TextButton(
            child: Text("Ok", style: TextStyle(color: Colors.blue)),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Home()));
            }),
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  eventOldCantBookDialog() {
    AlertDialog alert = AlertDialog(
      title: Text(
        'Old event',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      content: Text(
        'You can\'t book this event, its time has passed.',
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      actions: [
        TextButton(
            child: Text("Ok", style: TextStyle(color: Colors.blue)),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Home()));
            }),
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  String _textFromFile = "";
  late DocumentSnapshot documentList;
  // will return eventCreator name
  void eventCreator(String uid) async {
    String uesrName = " ";

    documentList =
        await FirebaseFirestore.instance.collection('uesrInfo').doc(uid).get();

    uesrName = documentList['name'];

    setState(() => _textFromFile = uesrName);
  }
}

class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstPoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstPoint.dx, firstPoint.dy);

    var secondControlPoint = Offset(size.width - (size.width / 4), size.height);
    var secondPoint = Offset(size.width, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondPoint.dx, secondPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Set<Polyline> _polylines = Set<Polyline>();
// List<LatLng> polylineCoordinates = [];
// PolylinePoints polylinePoints = new PolylinePoints();

// void setPolylines(LatLng a, double curLat, double curLong) async {
//   //LatLng cur = LatLng(curLat, curLong);
//   //getDirection(cur, a);
//   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//     "AIzaSyDLPzEuq9j9sCXxxfr-U7LZMulEVeIbKKg", //"AIzaSyDLPzEuq9j9sCXxxfr-U7LZMulEVeIbKKg",
//     PointLatLng(a.latitude, a.longitude),
//     PointLatLng(curLong, curLat),
//     travelMode: TravelMode.driving,
//   );
//   polylineCoordinates.clear();
//   print(result.status);
//   if (result.status == 'OK') {
//     result.points.forEach((PointLatLng point) {
//       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//     });

//     _polylines.add(Polyline(
//         width: 5,
//         polylineId: PolylineId('polyLine'),
//         color: Colors.orangeAccent,
//         points: polylineCoordinates));
//   }
// }


