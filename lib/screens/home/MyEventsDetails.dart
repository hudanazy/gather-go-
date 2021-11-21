import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:gather_go/screens/admin/adminEvent.dart';
//import 'package:gather_go/shared/dialogs.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gather_go/screens/admin/eventDetails.dart';
import 'package:gather_go/screens/home/EditEventForm.dart';
import 'package:gather_go/screens/myAppBar.dart';
import 'package:gather_go/services/database.dart';
import 'package:gather_go/shared/dialogs.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'MyEvents.dart';
import 'edit_profile_form.dart';

// ignore: camel_case_types
class MyEventsDetails extends StatefulWidget {
  final DocumentSnapshot? event;
  MyEventsDetails({required this.event});

  @override
  _MyEventsDetails createState() => new _MyEventsDetails();
}

// ignore: camel_case_types
class _MyEventsDetails extends State<MyEventsDetails> {
  @override
  Widget build(BuildContext context) {
    int attendeeNum = widget.event?.get('attendees');
    String userID = widget.event?.get('uid');
    //String eventUID = widget.event?.uid;
    String category = widget.event?.get('category');
    bool adminCheck = widget.event?.get('adminCheck');
    bool approved = widget.event?.get('approved');
    String state = "";
    Color stateColor = Colors.grey;
    List<Marker> myMarker = [];

    LatLng markerPosition =
        LatLng(widget.event?.get('lat'), widget.event?.get('long'));

    setState(() {
      myMarker.add(Marker(
        markerId: MarkerId(markerPosition.toString()),
        infoWindow: InfoWindow(title: widget.event?.get('name')),
        position: markerPosition, // markerPosition,
        // draggable: true,
        icon: BitmapDescriptor.defaultMarker,
      ));
    });

    if (adminCheck == false) {
      state = "Wating";
      stateColor = Colors.grey;
    } else if (adminCheck == true && approved == false) {
      state = "Disapprove";
      stateColor = Colors.red;
    } else if (adminCheck == true && approved == true) {
      state = "Approved";
      stateColor = Colors.lightGreen;
    }

    return Scaffold(
      appBar: SecondaryAppBar(title: 'Event Details',),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
            //  child: ArcBannerImage(),
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
                        color: Colors.orange[400],
                        fontFamily: 'Comfortaa',
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              )),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Chip(
                  label: Text(category, style: TextStyle(color: Colors.black)),
                  backgroundColor: Colors.deepOrange[100],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Chip(
                  label: Text(state, style: TextStyle(color: Colors.black)),
                  backgroundColor: stateColor,
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
                  Text("   " +
                      widget.event?.get('date').substring(0, 10) +
                      "  " +
                      widget.event?.get('time').substring(10, 15) +
                      '                                                           '), // we may need to change it as i dont think this the right time !!
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 20.0),
            //   child: Row(
            //     children: <Widget>[
            //       Icon(Icons.location_pin),
            //       Text("   to be added later"),
            //     ],
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(children: <Widget>[
                Icon(Icons.people_alt_rounded),
                Text("   Max attendee number is $attendeeNum  ")
              ]),
            ),
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
                          )),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                      ),
                      //color: Colors.deepOrange,
                      onPressed: () {
                        showMapdialogAdmin(context, myMarker);
                      },
                      //child: Text("see the location"),
                    ),
                  ],
                )),

//Start
            Row(
              children: [
                Expanded(
                    child: Align(
                        alignment: Alignment.bottomCenter, //her
                        child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.orangeAccent),
                            ),
                            child: Text('Delete Event',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Comfortaa',
                                    fontSize: 12)),
                            onPressed: () async {
                              var result = await showDdeleteDialog(context);
                              if (result == true) {
                                try {
                                  FirebaseFirestore.instance
                                      .collection('events')
                                      .doc(widget.event?.id)
                                      .delete();
                                  Fluttertoast.showToast(
                                    msg: widget.event?.get('name') +
                                        " delete successfully",
                                    toastLength: Toast.LENGTH_LONG,
                                  );
                                  Navigator.pop(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyEvents()));
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
                                  Colors.orangeAccent),
                            ),
                            child: Text('Edit Event',
                                style: TextStyle(
                                    color: Colors.black,
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
                                      builder: (context) =>
                                          EidtEventForm(event: widget.event)));
                            })))
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Edescription extends StatelessWidget {
  Edescription(this.description);
  final String description;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Event description ',
          style: textTheme.subtitle1!.copyWith(fontSize: 18.0),
        ),
        SizedBox(height: 8.0),
        Text(
          description,
          style: textTheme.bodyText2!.copyWith(
            color: Colors.black45,
            fontSize: 16.0,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
        ),
      ],
    );
  }
}

class ArcBannerImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ArcClipper(),
      child: Image.asset(
        'images/logo1.png',
        width: 400,
        height: 230.0,
        fit: BoxFit.cover,
      ),
    );
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
