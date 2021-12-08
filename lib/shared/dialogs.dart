import 'package:flutter/material.dart';
import 'package:gather_go/screens/home/MyEvents.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<bool> showMyDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Send event"),
      content: Text(
          "The event request will now be sent for approval. Are you sure you want to continue?"),
      actions: [
        TextButton(
            child: Text("No",
                //             Text('Are you sure you want to continue?"'),,
                style: TextStyle(color: Colors.grey)),
            onPressed: () {
              Navigator.pop(context, false);
            }),
        TextButton(
            child: Text("Yes", style: TextStyle(color: Colors.blue)),
            onPressed: () {
              Navigator.pop(context, true);
            })
      ],
    ),
  );
}

Future<bool> showApproveDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Approve event"),
      content: Text("Are you sure you want to approve this event ?"),
      actions: [
        TextButton(
            child: Text("No",
                //             Text('Are you sure you want to continue?"'),,
                style: TextStyle(color: Colors.grey)),
            onPressed: () {
              Navigator.pop(context, false);
            }),
        TextButton(
            child: Text("Yes", style: TextStyle(color: Colors.blue)),
            onPressed: () {
              Navigator.pop(context, true);
            })
      ],
    ),
  );
}

Future<bool> showDispproveDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Disapprove event"),
      content: Text("Are you sure you want to disapprove this event ?"),
      actions: [
        TextButton(
            child: Text("No",
                //             Text('Are you sure you want to continue?"'),,
                style: TextStyle(color: Colors.grey)),
            onPressed: () {
              Navigator.pop(context, false);
            }),
        TextButton(
            child: Text("Yes", style: TextStyle(color: Colors.blue)),
            onPressed: () {
              Navigator.pop(context, true);
            })
      ],
    ),
  );
}
void _onMapCreated(GoogleMapController _cntlr) {
  GoogleMapController _controller = _cntlr;
}



Future<bool> showMapdialogAdmin(
    BuildContext context, List<Marker> myMarker, LatLng markerPosition ) async {
  return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Positioned(
                right: -40.0,
                top: -40.0,
                child: InkResponse(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                  },
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true)
                          .pop('dialog'); //do what you want here
                    },
                    child: CircleAvatar(
                      child: Icon(Icons.close),
                      backgroundColor: Colors.deepOrange,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 500,
                width: 450,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  mapType: MapType.normal,
                  markers: Set.from(myMarker),
                  myLocationEnabled: true,
                  indoorViewEnabled:true,
                  compassEnabled: true,
                  zoomControlsEnabled: true,
                  mapToolbarEnabled: true,
                  trafficEnabled: false,
                  zoomGesturesEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: markerPosition,
                    zoom: 7.0,
                  ),
                ),
              ),
            ],
          ),
        );
      });
}

Future<bool> showDdeleteDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Delete event"),
      content: Text("Are you sure you want to delete this event ?"),
      actions: [
        TextButton(
            child: Text("No",
                //             Text('Are you sure you want to continue?"'),,
                style: TextStyle(color: Colors.grey)),
            onPressed: () {
              Navigator.pop(context, false);
            }),
        TextButton(
            child: Text("Yes", style: TextStyle(color: Colors.blue)),
            onPressed: () {
              Navigator.pop(context, true);
            })
      ],
    ),
  );
}

Future<bool> showBookDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Book event"),
      content: Text("Are you sure you want to book this event ?"),
      actions: [
        TextButton(
            child: Text("No", style: TextStyle(color: Colors.grey)),
            onPressed: () {
              Navigator.pop(context, false);
            }),
        TextButton(
            child: Text("Yes", style: TextStyle(color: Colors.blue)),
            onPressed: () {
              Navigator.pop(context, true);
            })
      ],
    ),
  );
}

Future<bool> showReportCommentDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Report Comment"),
      content: Text("Are you sure you want to report this comment?"),
      actions: [
        TextButton(
            child: Text("No", style: TextStyle(color: Colors.grey)),
            onPressed: () {
              Navigator.pop(context, false);
            }),
        TextButton(
            child: Text("Yes", style: TextStyle(color: Colors.blue)),
            onPressed: () {
              Navigator.pop(context, true);
            })
      ],
    ),
  );
}

Future<bool> showEditEventDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Edit event"),
      content: Text("Are you sure you want to Edit this event ?"),
      actions: [
        TextButton(
            child: Text("No",
                //
                style: TextStyle(color: Colors.grey)),
            onPressed: () {
              Navigator.pop(context, false);
            }),
        TextButton(
            child: Text("Yes", style: TextStyle(color: Colors.blue)),
            onPressed: () {
              Navigator.pop(context, true);

              // MaterialPageRoute(builder: (context) {
              //   //var editEventForm = EidtEventForm();
              //   //return editEventForm;
              // });
            })
      ],
    ),
  );
}

Future<bool> showEditEventApproved(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Edit event"),
      content: Text("this event is approved can't edit"),
      actions: [
        TextButton(
            child: Text("Ok", style: TextStyle(color: Colors.blue)),
            onPressed: () {
              Navigator.pop(
                  context);
            }),
      ],
    ),
  );
}
Future<bool> showAdminIgnoreCommentDialog(BuildContext context, String name) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Ignore comment"),
      content: Text("Are you sure you want to ignore $name's comment ?"),
      actions: [
        TextButton(
            child: Text("No", style: TextStyle(color: Colors.grey)),
            onPressed: () {
              Navigator.pop(context, false);
            }),
        TextButton(
            child: Text("Yes", style: TextStyle(color: Colors.blue)),
            onPressed: () {
              Navigator.pop(context, true);
            })
      ],
    ),
  );
}
Future<bool> showAdminDeleteCommentDialog(BuildContext context, String name) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Ignore comment"),
      content: Text("Are you sure you want to delete $name's comment ?"),
      actions: [
        TextButton(
            child: Text("No", style: TextStyle(color: Colors.grey)),
            onPressed: () {
              Navigator.pop(context, false);
            }),
        TextButton(
            child: Text("Yes", style: TextStyle(color: Colors.blue)),
            onPressed: () {
              Navigator.pop(context, true);
            })
      ],
    ),
  );
}
Future<bool> showUserDeleteCommentDialog(BuildContext context, String comment) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Ignore comment"),
      content: Text("Are you sure you want to delete '$comment' comment ?"),
      actions: [
        TextButton(
            child: Text("No", style: TextStyle(color: Colors.grey)),
            onPressed: () {
              Navigator.pop(context, false);
            }),
        TextButton(
            child: Text("Yes", style: TextStyle(color: Colors.blue)),
            onPressed: () {
              Navigator.pop(context, true);
            })
      ],
    ),
  );
}


  // return showDialog<void>(
  //   context: context,
  //   barrierDismissible: false, // user must tap button!
  //   builder: (BuildContext context) {
  //     return AlertDialog(
  //       title: const Text('Send event?'),
  //       content: SingleChildScrollView(
  //         child: ListBody(
  //           children: const <Widget>[
  //             Text("The event request will now be sent for approval."),
  //             Text('Are you sure you want to continue?"'),
  //           ],
  //         ),
  //       ),
  //       actions: <Widget>[
  //         TextButton(
  //           child: const Text('No'),
  //           onPressed: () {
  //             Navigator.pop(context, false);
  //           },
  //         ),
  //         TextButton(
  //           child: const Text('Send event'),
  //           onPressed: () {
  //             Navigator.pop(context, true);
  //           },
  //         ),
  //       ],
  //     );
  //   },
  // );


