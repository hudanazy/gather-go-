import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';

import 'package:gather_go/screens/admin/adminEvent.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gather_go/screens/admin/eventdetailsLogo.dart';
import 'package:gather_go/screens/myAppBar.dart';

import 'package:gather_go/services/database.dart';
import 'package:gather_go/shared/dialogs.dart';
import 'package:intl/message_format.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//import 'package:flutter_polyline_points/flutter_polyline_points.dart';
//import 'package:location/location.dart';
// import 'package:geolocator/geolocator.dart';
// import 'dart:math' show cos, sqrt, asin;

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
    int attendeeNum = widget.event?.get('attendees');
    String userID = widget.event?.get('uid');
    //LatLng _initialcameraposition = LatLng(24.708481, 46.752108);
    String category = widget.event?.get('category');
    List<Marker> myMarker = [];
//DatabaseService db = DatabaseService(widget.event?.id);
//add your lat and lng where you wants to draw polyline
    eventCreator(userID);
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

    return Scaffold(
      appBar: SecondaryAppBar(
        title: 'Event Details',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              //   child: ArcBannerImage(),
            ),

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
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
              ),
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
                child: Text(
                  widget.event?.get('name') + '   ',
                  style: TextStyle(
                      color: Colors.orange[300],
                      fontFamily: 'Comfortaa',
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              )),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Chip(
                  label: Text(category, style: TextStyle(color: Colors.black)),
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
                  )
                ],
              ),
            ),
            //   Padding(padding: const EdgeInsets.only(left: 20.0),
            //  child: Row(children: <Widget>[
            //     Text("        ")])),
            Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Flexible(
                  child: Row(children: <Widget>[
                    Icon(Icons.people_alt_rounded),
                    Text("   Max attendee number is $attendeeNum  ")
                  ]),
                )),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 20.0),
              child: Row(children: <Widget>[
                Icon(
                  Icons.person_rounded,
                ),
                Text("   Created by   $_textFromFile")
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
                    // ElevatedButton.icon(
                    //   icon: Icon(
                    //     Icons.location_pin,
                    //     color: Colors.black,
                    //   ),
                    //   label: Text("details",
                    //       style: TextStyle(
                    //         color: Colors.black87,
                    //       )),
                    //   style: ElevatedButton.styleFrom(
                    //     primary: Colors.white,
                    //   ),
                    //   //color: Colors.deepOrange,
                    //   onPressed: () {
                    //     //showMapdialogAdmin(context, myMarker);
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => eventDetailsForUesers(
                    //                   event: widget.event,
                    //                 )));
                    //   },
                    //child: Text("see the location"),
                    //),
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
                        showMapdialogAdmin(context, myMarker, markerPosition);
                      },
                      //child: Text("see the location"),
                    ),
                  ],
                )),
            Row(
              children: [
                Expanded(
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                          child: Text('Disapprove',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Comfortaa',
                                  fontSize: 16)),
                          onPressed: () async {
                            var result = await showDispproveDialog(context);
                            if (result == true) {
                              try {
                                await DatabaseService(uid: widget.event?.id)
                                    .disapproveEvent();

                                // success msg + redirect to adminEvent

                                Fluttertoast.showToast(
                                  msg: widget.event?.get('name') +
                                      " dispproved successfully",
                                  toastLength: Toast.LENGTH_LONG,
                                );

                                Navigator.pop(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => adminEvent()));
                              } catch (e) {
                                // fail msg
                                Fluttertoast.showToast(
                                  msg: "somthing went wrong ",
                                  toastLength: Toast.LENGTH_SHORT,
                                );
                              }
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.orange[300]),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.fromLTRB(35, 15, 35, 15))),
                        ))),
                Expanded(
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        child: Text('Approve',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Comfortaa',
                                fontSize: 16)),
                        onPressed: () async {
                          var result = await showApproveDialog(context);
                          if (result == true) {
                            try {
                              await DatabaseService(uid: widget.event?.id)
                                  .approveEvent();

                              Fluttertoast.showToast(
                                msg: widget.event?.get('name') +
                                    " approved successfully",
                                toastLength: Toast.LENGTH_LONG,
                              );
                              Navigator.pop(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => adminEvent()));
                            } catch (e) {
                              // fail msg
                              Fluttertoast.showToast(
                                msg: "Somthing went wrong ",
                                toastLength: Toast.LENGTH_SHORT,
                              );
                            }
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.orange[300]),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.fromLTRB(35, 15, 35, 15))),
                      )),
                )
              ],
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  // Location _location = Location();
  // late GoogleMapController _controller;
  // void _onMapCreated(GoogleMapController _cntlr) {
  //   _controller = _cntlr;
  // }

  String _textFromFile = "";
  // will return eventCreator name
  void eventCreator(String uid) async {
    String uesrName = " ";
    DocumentSnapshot documentList;
    documentList =
        await FirebaseFirestore.instance.collection('uesrInfo').doc(uid).get();

    uesrName = documentList['name'];

    setState(() => _textFromFile = uesrName);
  }
}
