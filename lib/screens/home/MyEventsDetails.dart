import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gather_go/screens/admin/adminEvent.dart';
//import 'package:gather_go/shared/dialogs.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gather_go/shared/dialogs.dart';

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

    String category = widget.event?.get('category');
    bool adminCheck = widget.event?.get('adminCheck');
    bool approved = widget.event?.get('approved');
    String state = "";
    Color stateColor = Colors.grey;

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

    Future<String> eventCreatorName = eventCreator(userID);

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
                        color: Colors.black,
                        fontFamily: 'Comfortaa',
                        fontSize: 18)),
              ),
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
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.location_pin),
                  Text("   to be added later"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(children: <Widget>[
                Icon(Icons.people_alt_rounded),
                Text("   Max attendee number is $attendeeNum  ")
              ]),
            )
            /*Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 20.0),
              child: Row(children: <Widget>[
                Icon(
                  Icons.person_rounded,
                ),
                Text("   Created by   $_textFromFile")
              ]),
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
                                  "location": widget.event?.get('location')
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
                                "location": widget.event?.get('location')
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
            )*/
          ],
        ),
      ),
    );
  }

  String _textFromFile = "";
  // will return eventCreator name
  Future<String> eventCreator(String uid) async {
    String uesrName = " ";
    DocumentSnapshot documentList;
    documentList =
        await FirebaseFirestore.instance.collection('uesrInfo').doc(uid).get();

    uesrName = documentList['uesrname'];

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
