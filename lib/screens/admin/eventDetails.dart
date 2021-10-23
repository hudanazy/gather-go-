//import 'dart:math';
//import 'package:geolocation/geolocation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gather_go/screens/admin/adminEvent.dart';
//import 'package:gather_go/shared/dialogs.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gather_go/shared/dialogs.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
//import 'package:location/location.dart' ;

//import 'package:geocoder/geocoder.dart' as geoCo;

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
    // Object for PolylinePoints

    print("asdfgfds");
    final startAddressController = TextEditingController();
    // Future<String> eventCreatorName = eventCreator(userID);
    _createPolylines(24.814953633808596, 46.61074977772709);
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
          onDragEnd: (dragEndPosition) {
            print(dragEndPosition);
          }));
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
                    myLocationEnabled: true,
                    compassEnabled: true,
                    zoomControlsEnabled: true,
                    mapToolbarEnabled: true,
                    trafficEnabled: true,
                    zoomGesturesEnabled: true,
                    polylines: Set<Polyline>.of(polylines.values),
                    initialCameraPosition: CameraPosition(
                      target: _initialcameraposition,
                      zoom: 10.0,
                    ),
                  ),
                  // GoogleMap(
                  //   initialCameraPosition: CameraPosition(
                  //       target: LatLng(40.69714947153292, -74.27361247497824),
                  //       zoom: 14),
                  //   mapType: MapType.normal,
                  //   // onMapCreated: _onMapCreated,
                  //   // myLocationEnabled: true,
                  //   // compassEnabled: true,
                  //   // mapToolbarEnabled: true,
                  //   // trafficEnabled: true,
                  //   // zoomGesturesEnabled: true,
                  //   // markers: Set<Marker>.of(myMarker),
                  // ),
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

// void _updateCameraPosition(CameraPosition position) {
//     setState(() {
//       _location = position;
//     });
//   }
  var pinLocationIcon;
  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/icon/pin.png');
  }
//   dynamic _getAddress() async {
//   try {
//     // Places are retrieved using the coordinates
//     List<Placemark> p = await placemarkFromCoordinates(
//         markerPosition);

//     // Taking the most probable result
//     Placemark place = p[0];

//     setState(() {

//       // Structuring the address
//       _currentAddress =
//           "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";

//       // Update the text of the TextField
//       startAddressController.text = _currentAddress;

//       // Setting the user's present location as the starting address
//       _startAddress = _currentAddress;
//     });
//   } catch (e) {
//     print(e);
//   }
// }

  // Location _location = Location();
  late GoogleMapController _controller;
  late List<Marker> myMarker;
  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
  }

  double latitude = 00.00000;
  double longitude = 00.00000;
//Now Create Method named _getCurrentLocation with async Like Below.

  late PolylinePoints polylinePoints;

// List of coordinates to join
  List<LatLng> polylineCoordinates = [];

// Map storing polylines created by connecting two points
  Map<PolylineId, Polyline> polylines = {};
  _createPolylines(
    double startLatitude,
    double startLongitude,
  ) async {
    // Initializing PolylinePoints
    polylinePoints = PolylinePoints();

    // Generating the list of coordinates to be used for
    // drawing the polylines
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyDPdn-l7AIoVnPYqR37vXdrH9dVVHHCckM", // Google Maps API Key
      PointLatLng(latitude, longitude),
      PointLatLng(widget.event?.get('lat'), widget.event?.get('long')),
      travelMode: TravelMode.transit,
    );

    // Adding the coordinates to the list
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    // Defining an ID
    PolylineId id = PolylineId('poly');

    // Initializing Polyline
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );

    // Adding the polyline to the map
    polylines[id] = polyline;
  }

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
