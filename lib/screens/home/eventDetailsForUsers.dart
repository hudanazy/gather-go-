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

import '../NotifactionManager.dart';

// ignore: camel_case_types
class eventDetailsForUesers extends StatefulWidget {
  final DocumentSnapshot? event;
  eventDetailsForUesers({required this.event});

  @override
  _eventDetails createState() => new _eventDetails();
}

// ignore: camel_case_types
class _eventDetails extends State<eventDetailsForUesers> {
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
    // final snap = FirebaseFirestore.instance
    // .collection('uesrInfo').doc(userID).collection('bookedEvents').where('uid', isEqualTo: widget.event!.id).snapshots();
    final buttonColor;
    List list = widget.event?.get('attendeesList');
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    if (bookedNum < attendeeNum &&
        !list.contains(currentUser) &&
        eventDate.toDate().isAfter(DateTime.now()))
      buttonColor = Colors.orange[300];
    else
      buttonColor = Colors.grey[600];

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
                    )
                  ]),
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
                      Text("   Created by "),
                      ElevatedButton(
                        child: Text(" $_textFromFile ",
                            style: TextStyle(
                              color: Colors.orange[300],
                              fontFamily: 'Comfortaa',
                              fontWeight: FontWeight.bold,
                            )),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                        ),
                        //color: Colors.deepOrange,
                        onPressed: () {
                          // ProfileForm();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => viewProfile(
                                      user: documentList,
                                      event: widget.event)));
                        },
                        //child: Text("see the location"),
                      )
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
                  Padding(
                      padding: const EdgeInsets.only(right: 20.0, bottom: 20.0),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            icon: Icon(
                              Icons.book,
                              color: Colors.white,
                            ),
                            label: Text('Book event',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Comfortaa',
                                  fontSize: 12,
                                )),
                            style: ElevatedButton.styleFrom(
                              primary: buttonColor,
                            ),
                            onPressed: () async {
                              List list = widget.event?.get('attendeesList');
                              var eventDate = widget.event?.get("browseDate");
                              if (list.contains(currentUser)) {
                                AlertDialog alert = AlertDialog(
                                  title: Text(
                                    'Event booked',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                  content: Text(
                                    'Are you sure you want to cancel your booking for this event?',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                        child: Text("Yes",
                                            style:
                                                TextStyle(color: Colors.blue)),
                                        onPressed: () {
                                          try {
                                            List list = widget.event
                                                ?.get('attendeesList');
                                            list.remove(currentUser);
                                            FirebaseFirestore.instance
                                                .collection('events')
                                                .doc(widget.event?.id)
                                                .update({
                                              "bookedNumber": bookedNum - 1,
                                              "attendeesList": list
                                            });
                                            Fluttertoast.showToast(
                                              msg: widget.event?.get('name') +
                                                  " Booking successfully canceled",
                                              toastLength: Toast.LENGTH_LONG,
                                            );
                                            Fluttertoast.showToast(
                                              msg: widget.event?.get('name') +
                                                  " Booking successfully canceled",
                                              toastLength: Toast.LENGTH_LONG,
                                            );
                                            Navigator.pop(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Home()));
                                          } catch (e) {
                                            // fail msg
                                            Fluttertoast.showToast(
                                              msg: "Somthing went wrong ",
                                              toastLength: Toast.LENGTH_SHORT,
                                            );
                                          }
                                        }),
                                    TextButton(
                                        child: Text("No",
                                            style:
                                                TextStyle(color: Colors.blue)),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Home()));
                                        })
                                  ],
                                );
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return alert;
                                    });
                              } else if (eventDate
                                  .toDate()
                                  .isBefore(DateTime.now())) {
                                eventOldCantBookDialog();
                              } else {
                                if (bookedNum < attendeeNum) {
                                  // StreamBuilder<Object>(
                                  //   stream: snap,
                                  //   builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
                                  //     if (snapshot.data.size ==0)
                                  //     return eventBookedDialog();
                                  //     print('success');
                                  //   },
                                  // );

                                  var result = await showBookDialog(context);
                                  if (result == true) {
                                    var eventDate = widget.event?.get('date');
                                    var eventTime = widget.event?.get('time');
                                    // NotifactionManager().showAttendeeNotification(1, "Reminder, your booked event",
                                    //         widget.event?.get('name')+" event starts in 2 hours, don't forget it",
                                    //         eventDate, eventTime);
                                    NotifactionManager().showAttendeeNotification(
                                        1,
                                        "Reminder, your booked event",
                                        widget.event?.get('name') +
                                            " starts tomorrow, don't forget it",
                                        eventDate,
                                        eventTime);
                                    try {
                                      List list =
                                          widget.event?.get('attendeesList');
                                      list.add(currentUser);
                                      FirebaseFirestore.instance
                                          .collection('events')
                                          .doc(widget.event?.id)
                                          .update({
                                        "bookedNumber": bookedNum + 1,
                                        "attendeesList": list
                                      });
                                      // DatabaseService()
                                      //     .addBookedEventToProfile(widget.event!.id);
                                      Fluttertoast.showToast(
                                        msg: widget.event?.get('name') +
                                            " booked successfully, you can view it in your profile",
                                        toastLength: Toast.LENGTH_LONG,
                                      );
                                      Navigator.pop(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Home()));
                                    } catch (e) {
                                      // fail msg
                                      Fluttertoast.showToast(
                                        msg: "Somthing went wrong ",
                                        toastLength: Toast.LENGTH_SHORT,
                                      );
                                    }
                                  }
                                } else {
                                  AlertDialog alert = AlertDialog(
                                    title: Text('Fully booked'),
                                    content: Text(
                                      'Sorry, all event\'s seats are booked.\nPlease choose another event to attend.',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                          child: Text("Ok",
                                              style: TextStyle(
                                                  color: Colors.blue)),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Home()));
                                          }),
                                    ],
                                  );
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return alert;
                                      });
                                }
                              }
                            },
                          ),
                        ],
                      ))
                ],
              ),
            ),
          );
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
