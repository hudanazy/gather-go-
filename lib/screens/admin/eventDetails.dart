import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:gather_go/screens/admin/adminEvent.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gather_go/shared/dialogs.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';
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
    LatLng _initialcameraposition = LatLng(24.708481, 46.752108);
    String category = widget.event?.get('category');
    List<Marker> myMarker = [];

//add your lat and lng where you wants to draw polyline

    LatLng markerPosition =
        LatLng(widget.event?.get('lat'), widget.event?.get('long'));
    setState(() {
      myMarker = [];
      myMarker.add(Marker(
        markerId: MarkerId(markerPosition.toString()),
        infoWindow: InfoWindow(title: widget.event?.get('name')),
        position: markerPosition, // markerPosition,
        // draggable: true,
        icon: BitmapDescriptor.defaultMarker,
      ));
      myMarker.add(Marker(
        // uesr current location
        markerId: MarkerId(markerPosition.toString()), //to be changed to curr
        infoWindow: InfoWindow(title: "you"),
        position: LatLng(24.81072717400907,
            46.59894805752124), //to be changed to curr // markerPosition,
        // draggable: true,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ));
      _polylines.add(Polyline(
          width: 10,
          polylineId: PolylineId('polyLine'),
          color: Color(0xFF08A5CB),
          points: polylineCoordinates));
    });

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: ArcBannerImage(),
            ),
            Row(children: [
              IconButton(
                icon: new Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context,
                      MaterialPageRoute(builder: (context) => adminEvent()));
                },
              ),
              Flexible(
                child: Text(widget.event?.get('name') + '   ',
                    style: TextStyle(
                        color: Colors.deepOrange,
                        fontFamily: 'Comfortaa',
                        fontSize: 18)),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Chip(
                  label: Text(category, style: TextStyle(color: Colors.black)),
                  backgroundColor: Colors.deepOrange[100],
                ),
              )
            ]),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Edescription(widget.event?.get('description')),
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Icon(Icons.access_time),
                Text("   " +
                    widget.event?.get('date').substring(0, 10) +
                    "  " +
                    widget.event?.get('time').substring(10, 15) +
                    '                                                           '), // we may need to change it as i dont think this the right time !!
              ],
            ),
            Row(children: <Widget>[
              Text("        "),
              Icon(Icons.people_alt_rounded),
              Text("   Max attendee number is $attendeeNum  ")
            ]),
            Row(children: <Widget>[
              Text("        "),
              Icon(
                Icons.person_rounded,
              ),
              Text("   Created by   $_textFromFile")
            ]),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Icon(Icons.location_pin),
                Text(
                    "   to be added later                                                              "),
                // RaisedButton(
                //   onPressed: () {
                //     showDialog(
                //         context: context,
                //         builder: (BuildContext context) {
                //           return AlertDialog(
                //             content: Stack(
                //               overflow: Overflow.visible,
                //               children: <Widget>[
                //                 Positioned(
                //                   right: -40.0,
                //                   top: -40.0,
                //                   child: InkResponse(
                //                     onTap: () {
                //                       Navigator.of(context).pop();
                //                     },
                //                     child: CircleAvatar(
                //                       child: Icon(Icons.close),
                //                       backgroundColor: Colors.deepOrange,
                //                     ),
                //                   ),
                //                 ),
                SizedBox(
                  height: 500,
                  width: 450,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    markers: Set.from(myMarker),
                    polylines: _polylines,
                    myLocationEnabled: true,
                    compassEnabled: true,
                    zoomControlsEnabled: true,
                    mapToolbarEnabled: true,
                    trafficEnabled: true,
                    zoomGesturesEnabled: true,
                    //onTap: setPolylines,
                    initialCameraPosition: CameraPosition(
                      target: _initialcameraposition,
                      zoom: 10.0,
                    ),
                  ),
                ),
                //               ],
                //             ),
                //           );
                //         });
                //   },
                //   child: Text("see the location"),
                // ),
              ],
            ),
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
                                  fontSize: 12)),
                          onPressed: () async {
                            var result = await showDispproveDialog(context);
                            if (result == true) {
                              try {
                                FirebaseFirestore.instance
                                    .collection('events')
                                    .doc(widget.event?.id)
                                    .set({
                                  "uid": userID,
                                  "name": widget.event?.get('name'),
                                  "description":
                                      widget.event?.get('description'),
                                  "timePosted": widget.event?.get('timePosted'),
                                  "attendees": attendeeNum,
                                  "date": widget.event?.get('date'),
                                  "time": widget.event?.get('time'),
                                  "category": category,
                                  'approved': false,
                                  "adminCheck": true,
                                  "lat": widget.event?.get('lat'),
                                  "long": widget.event?.get('long'),
                                });
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
                                fontSize: 12)),
                        onPressed: () async {
                          var result = await showApproveDialog(context);
                          if (result == true) {
                            try {
                              FirebaseFirestore.instance
                                  .collection('events')
                                  .doc(widget.event?.id)
                                  .set({
                                "uid": userID,
                                "name": widget.event?.get('name'),
                                "description": widget.event?.get('description'),
                                "timePosted": widget.event?.get('timePosted'),
                                "attendees": attendeeNum,
                                "date": widget.event?.get('date'),
                                "category": category,
                                "time": widget.event?.get('time'),
                                'approved': true,
                                "adminCheck": true,
                                "lat": widget.event?.get('lat'),
                                "long": widget.event?.get('long'),
                              });
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
                                MaterialStateProperty.all(Colors.purple[300]),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.fromLTRB(35, 15, 35, 15))),
                      )),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  // Location _location = Location();
  late GoogleMapController _controller;
  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
  }

// distanceCalculation () async {
//   double distanceInMeters = await Geolocator.bearingBetween(
//   startLatitude,
//   startLongitude,
//   destinationLatitude,
//   destinationLongitude,
// );
// }
  String _textFromFile = "";
  // will return eventCreator name
  Future<String> eventCreator(String uid) async {
    String uesrName = " ";
    DocumentSnapshot documentList;
    documentList =
        await FirebaseFirestore.instance.collection('uesrInfo').doc(uid).get();

    uesrName = documentList['name'];

    setState(() => _textFromFile = uesrName);

    return uesrName;
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

// res https://iiro.dev/from-design-to-flutter-movie-details-page/
Set<Polyline> _polylines = Set<Polyline>();
List<LatLng> polylineCoordinates = [];
PolylinePoints polylinePoints = PolylinePoints();

void setPolylines(LatLng a) async {
  PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyDLPzEuq9j9sCXxxfr-U7LZMulEVeIbKKg",
      PointLatLng(24.808058743555637, 46.60225256829246),
      PointLatLng(24.808058743555637, 46.60225256829246));

  if (result.status == 'OK') {
    result.points.forEach((PointLatLng point) {
      polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    });
  }
}
