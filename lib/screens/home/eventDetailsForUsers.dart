import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gather_go/Models/NewUser.dart';
import 'package:gather_go/screens/admin/adminEvent.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gather_go/screens/admin/eventdetailsLogo.dart';
import 'package:gather_go/screens/comment_screen.dart';
import 'package:gather_go/screens/home/home.dart';
import 'package:gather_go/screens/home/viewProfile.dart';
import 'package:gather_go/screens/myAppBar.dart';
import 'package:gather_go/shared/dialogs.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../NotifactionManager.dart';
import 'MyEvents.dart';
import 'Rating_view.dart';

//bool israting = false;
//var _rating = 0;

// ignore: camel_case_types
class eventDetailsForUesers extends StatefulWidget {
  final DocumentSnapshot? event;
  eventDetailsForUesers({required this.event});

  @override
  _eventDetails createState() => new _eventDetails();
}

// ignore: camel_case_types
class _eventDetails extends State<eventDetailsForUesers> {
  double rating = 0;
  int ratingCounter = 0;
  double ratingAVG = 0;
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
    /*  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RatingBar.builder(
          // initialRating: widget.event?.get('Rating'),
          initialRating: rating,
          minRating: 0,
          itemSize: 20,
          direction: Axis.horizontal,
          allowHalfRating: true,
          updateOnDrag: true,
          itemCount: 5,
          itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            setState(() {
              this.rating = rating;
            });
            print(rating);
          },
        ),
        Text('  ${rating == 0 ? '' : rating}',
            style: TextStyle(
              //  color: TEXTCOLOR,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            )),
        Text(
          ' *',
          style: TextStyle(color: Colors.red),
        )
      ],
    );
    SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    ); */

    //loop
    //Future<void> onDataChange(dataSnapshot) async {//metod rating change
//-----------------------------------------
    int sumRating = 0;
    List<int> listRating = [1, 4, 2, 5, 2, 1]; //list rating from doc db

    for (var i = 0; i < listRating.length; i++) {
      sumRating += listRating[i];
    }

    var averageRating = (sumRating / listRating.length); // This is average
    //------------------------------------------------------------------
    //var result = values.map((m) => m['rating']!).average; // prints 3.75

    //print(result);
    //double sum = ratings.fold(0, (p, c) => p + c);
//if (sum > 0) {
    //  double average = sum / ratings.length;
    // }

    // double Rating = double.parse(source);
    /*  Widget buildRating() => RatingBar.builder(
          // initialRating: widget.event?.get('Rating'),
          initialRating: rating,
          minRating: 0,
          itemSize: 20,
          direction: Axis.horizontal,
          allowHalfRating: true,
          updateOnDrag: true,
          itemCount: 5,
          itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            setState(() {
              this.rating = rating;
            });
            print(rating);
          },
        ); */
    final user = Provider.of<NewUser?>(context);
    //---------------------
    Stream<QuerySnapshot<Map<String, dynamic>>> snap = FirebaseFirestore
        .instance
        .collection('events')
        .where('uid', isEqualTo: user!.uid)
        .snapshots();
    //---------------------------------
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

    //double RatingNum =   widget.event!.get('RatingNum');
    // var rating = '';
    //-------------------her rating
    String userID = widget.event?.get('uid');
    String category = widget.event?.get('category');

    // final snap = FirebaseFirestore.instance
    // .collection('uesrInfo').doc(userID).collection('bookedEvents').where('uid', isEqualTo: widget.event!.id).snapshots();
    final buttonColor;
    List list = widget.event?.get('attendeesList');
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    if (bookedNum < attendeeNum && !list.contains(currentUser))
      buttonColor = Colors.deepPurple;
    else
      buttonColor = Colors.grey;

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

          /*      Widget buildRating() => RatingBar.builder(
                // initialRating: widget.event?.get('Rating'),
                initialRating: rating,
                minRating: 0,
                itemSize: 30,
                direction: Axis.horizontal,
                allowHalfRating: true,
                updateOnDrag: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    this.rating = rating;
                  });
                  print(rating);
                },
              ); */
          return Scaffold(
            appBar: SecondaryAppBar(
              title: 'Event Details',
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
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
                        label: Text(category,
                            style: TextStyle(color: Colors.black)),
                        backgroundColor: Colors.grey[350],
                      ),
                    ),
                  ]),

                  const SizedBox(height: 5),
                  //buildRating(),

                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Row(children: <Widget>[
                      //Icon(Icons.people_alt_rounded),
                      Text(
                        "  Rating event is",
                      )
                    ]),
                  ),
                  //----------------- i want save like icon star and retreve from db

                  buildRating(),

                  Padding(
                      padding: const EdgeInsets.only(right: 20.0, bottom: 20.0),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            icon: Icon(
                              Icons.star_rate,
                              color: Colors.yellow,
                            ),
                            label: Text("Rate!",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Comfortaa',
                                )),
                            style: ElevatedButton.styleFrom(
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                              primary: Colors.white,

                              // minimumSize: Size.fromWidth(180),
                            ),
                            onPressed: () async {
                              var result = await showRatingDialog(context);
                              if (result == true) {
                                try {
                                  FirebaseFirestore.instance
                                      .collection('events')
                                      .doc(widget.event?.id)
                                      .update({
                                    "rating": rating,
                                  });

                                  Fluttertoast.showToast(
                                    msg: " Thanks for your feedback for event" +
                                        widget.event?.get('name'),
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
                                /* if (result == true) {
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
                                } */
                              }
                            },
                          ),
                        ],
                      )),

                  //--------------------

                  /*   RatingBar.builder(
                    // initialRating: widget.event?.get('Rating'),
                    initialRating: rating,
                    minRating: 0,
                    itemSize: 20,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    updateOnDrag: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        this.rating = rating;
                      });
                      print(rating);
                    },
                  ), */
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
                              color: Colors.orange[400],
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
                              showMapdialogAdmin(context, myMarker);
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
                              if (list.contains(currentUser)) {
                                eventBookedDialog();
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
                      )),

                  //try rating

                  /* Container(
                      width: 210,
                      height: 94,
                      //color: Colors.blue.withOpacity(0.5),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                israting = true;
                              });
                            },
                          )
                        ],
                      ))
 */

                  //   buildRating(),
                  Padding(
                      padding: const EdgeInsets.only(right: 20.0, bottom: 20.0),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            icon: Icon(
                              Icons.star_rate,
                              color: Colors.yellow,
                            ),
                            label: Text("Rate!",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Comfortaa',
                                )),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              // minimumSize: Size.fromWidth(180),
                            ),
                            onPressed: () async {
                              var result = await showRatingDialog(context);
                              if (result == true) {
                                try {
                                  FirebaseFirestore.instance
                                      .collection('events')
                                      .doc(widget.event?.id)
                                      .update({
                                    "rating": rating,
                                  });

                                  Fluttertoast.showToast(
                                    msg: " Thanks for your feedback for event" +
                                        widget.event?.get('name'),
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
                                /* if (result == true) {
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
                                } */
                              }
                            },
                          ),
                        ],
                      )),
                ],
              ),
            ),
          );

          // ignore: dead_code
        });
  }

  Widget buildRating() => RatingBar.builder(
        // initialRating: widget.event?.get('Rating'),
        initialRating: rating,
        glow: true,
        //ignoreGestures: true,
        //glowColor: ,
        minRating: 1,
        itemSize: 30,
        direction: Axis.horizontal,
        allowHalfRating: true,
        updateOnDrag: true,
        itemCount: 5,
        itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
        itemBuilder: (context, _) => Icon(
          Icons.star,
          color: Colors.amber,
        ),
        onRatingUpdate: (value) {
          setState(() {
            rating = value;
          });
          print("$rating heeeeeeeeeeeeeeeeer");
        },
      );

  // Location _location = Location();
  // late GoogleMapController _controller;
  // void _onMapCreated(GoogleMapController _cntlr) {
  //   _controller = _cntlr;
  // }
//-----------------------------------------------------------

  //------------------------

  /*  RatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Rate This Event"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'We would like to get your feedback about this event',
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(
                height: 25,
              ),
              buildRating(),
            ],
          ),
          actions: [
            TextButton(
                child: Text("cancel",
                    //             Text('Are you sure you want to continue?"'),,
                    style: TextStyle(color: Colors.grey)),
                onPressed: () {
                  Navigator.pop(context, false);
                }),
            TextButton(
                child: Text("Ok", style: TextStyle(color: Colors.blue)),
                onPressed: () {
                  Navigator.pop(context, true);
                })
          ],
          /*    actions: [
            TextButton(
                child: Text("Ok", style: TextStyle(color: Colors.blue)),
                onPressed: () {
                  Navigator.pop(
                    context,

                    /* eventDetailsForUesers(
                                event: widget.event,
                              ) */
                  );
                }),
          ], */
        );
      },
    );
  } */

  Future<bool> showRatingDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Rate This Event"),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'We would like to get your feedback about this event',
              style: TextStyle(fontSize: 15),
            ),
            /* SizedBox(
              height: 25,
            ), */
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RatingBar.builder(
                  // initialRating: widget.event?.get('Rating'),
                  initialRating: rating,
                  minRating: 1,
                  itemSize: 20,
                  glow: true,
                  //direction: Axis.horizontal,
                  allowHalfRating: true,
                  updateOnDrag: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (value) {
                    setState(() {
                      rating = value;
                    });
                    // print(rating);
                  },
                ),
                Text('  ${rating == 0 ? '' : rating}',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    )),
                Text(
                  ' *',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
          ],
        ),
        actions: [
          TextButton(
              child: Text("cancel",
                  //             Text('Are you sure you want to continue?"'),,
                  style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.pop(context, false);
              }),
          TextButton(
              child: Text("Ok", style: TextStyle(color: Colors.blue)),
              onPressed: () {
                Navigator.pop(context, true);
              })
        ],
      ),
    );
  }

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

//update rating
  /* var collection;
  RatingArg() async {
    collection = await FirebaseFirestore.instance.collection('events');
    // .doc(widget.event?.id);
    documentList = await collection.get();

    /*  for (var doc in documentList.docs()) {
      // await doc.reference.update({"name": name, "imageUrl": img});
    } */
  } */

  /* QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("collection").get();
    var list = querySnapshot.docs; */
  Future getDocs() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("events").get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      // print(a.documentID);
    }
  }

// her
  var collection;
  RatingArg() async {
    collection = await FirebaseFirestore.instance
        .collection('events')
        .where('eventID', isEqualTo: widget.event?.id)
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        setState(() {
          ratingAVG += double.parse(element.data()['rating'].toString());
          print('rating');
          ratingCounter = event.docs.length;
        });
      });
    });

    //documentList = await collection.get();

    /*  for (var doc in documentList.docs()) {
      // await doc.reference.update({"name": name, "imageUrl": img});
    } */
  }
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

