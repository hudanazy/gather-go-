import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gather_go/screens/admin/adminEvent.dart';
//import 'package:gather_go/shared/dialogs.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
    Future<String> eventCreatorName = eventCreator(userID);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 100.0),
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
              Text(widget.event?.get('name'),
                  style: TextStyle(
                      color: Colors.deepOrange,
                      fontFamily: 'Comfortaa',
                      fontSize: 18)),
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
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Icon(Icons.location_pin),
                Text(
                    "   to be added later                                                              "),
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
            Row(
              children: [
                Expanded(
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                          child: Text('disapprove'),
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
                                  'approved': false,
                                  "adminCheck": true /* "location": location*/
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
                        child: Text('approve'),
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
                                "time": widget.event?.get('time'),
                                'approved': true,
                                "adminCheck": true /* "location": location*/
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
    path.lineTo(0.0, size.height - 30);

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
