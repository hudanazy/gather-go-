import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gather_go/screens/home/home.dart';
import 'package:gather_go/services/auth.dart';
import 'package:gather_go/services/database.dart';
import 'package:gather_go/shared/dialogs.dart';

import '../NotifactionManager.dart';

// ignore: camel_case_types
class browseEventDetails extends StatefulWidget {
  final DocumentSnapshot? event;
  browseEventDetails({required this.event});
  @override
  _browseEventDetails createState() => new _browseEventDetails();
}

// ignore: camel_case_types
class _browseEventDetails extends State<browseEventDetails> {
  @override
  Widget build(BuildContext context) {
    int attendeeNum = widget.event?.get('attendees');
    int bookedNum= widget.event!.get('bookedNumber');
    String userID = widget.event?.get('uid');
    String category = widget.event?.get('category');
    final buttonColor;
    //check if event already booked

    if(bookedNum < attendeeNum)
      buttonColor=Colors.amber;
    else
      buttonColor=Colors.grey;
    Future<String> eventCreatorName = eventCreator(userID);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 5.0),
            //   child: ArcBannerImage(),
            // ),
            Row(children: [
              IconButton(
                icon: new Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Flexible(
                child: Text(widget.event?.get('name') + '   ',
                    style: TextStyle(
                        color: Colors.amber,
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
            Padding( padding: const EdgeInsets.only(left: 20.0),
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
            Padding(padding: const EdgeInsets.only(left: 20.0),
            child:Row(children: <Widget>[
                Icon(Icons.location_pin),
                Text("   to be added later"),
              ],
            ),
            ),
            Padding(padding: const EdgeInsets.only(left: 20.0),
            child: Row(children: <Widget>[
              Icon(Icons.people_alt_rounded),
              Text("   Max attendee number is $attendeeNum  ")
            ]),
            ),
            Padding(padding: const EdgeInsets.only(left: 20.0, bottom: 20.0),
            child: Row(children: <Widget>[
              Icon(
                Icons.person_rounded,
              ),
              Text("   Created by   $_textFromFile")
            ]),
            ),
               Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        child: Text('Book event',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Comfortaa',
                                fontSize: 12)),
                        onPressed: () async {
                          if (bookedNum < attendeeNum){
                              var events;
                              String eventBooked='';
                              FirebaseFirestore.instance.collection('uesrInfo').doc(widget.event!.get('uid'))
                              .collection('bookedEvents').get().then((value) {
                                events= value.docs;
                                if (events != null){
                                for(var e in events)
                                  if(e.eventUid==widget.event!.id)
                                    eventBooked='true';

                                if (eventBooked=='true'){
                                  eventBookedDialog();
                                }
                              }});
                          var result = await showBookDialog(context);
                          if (result == true) {
                            var eventDate= widget.event?.get('date');
                            var eventTime = widget.event?.get('time');
                            NotifactionManager().showAttendeeNotification(1, "Reminder, your booked event",
                                    widget.event?.get('name')+" event starts in 2 hours, don't forget it", 
                                    eventDate, eventTime);
                            try {
                              FirebaseFirestore.instance
                                  .collection('events')
                                  .doc(widget.event?.id)
                                  .update({"bookedNumber": bookedNum+1,});
                              DatabaseService().addBookedEventToProfile(widget.event!.id);
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
                            AlertDialog alert= AlertDialog(
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
                                    style: TextStyle(color: Colors.blue)),
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true).pop();
                                }),
                              ],);
                              showDialog(context: context, builder: (BuildContext context){
                                return alert;
                              });
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(buttonColor),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.fromLTRB(35, 15, 35, 15))),
                      )),
                
            
          ],
        ),
      ),
    );
  }
  eventBookedDialog(){
    AlertDialog alert= AlertDialog(
      title: Text('Fully booked'),
      content: Text(
        'You already booked this event.',
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      actions: [
        TextButton(
          child: Text("Ok",
          style: TextStyle(color: Colors.blue)),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          }),
      ],);
    showDialog(context: context, builder: (BuildContext context){
      return alert;
    });
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

// class ArcBannerImage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ClipPath(
//       clipper: ArcClipper(),
//       child: Image.asset(
//         'images/logo1.png',
//         width: 400,
//         height: 230.0,
//         fit: BoxFit.cover,
//       ),
//     );
//   }
// }

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
