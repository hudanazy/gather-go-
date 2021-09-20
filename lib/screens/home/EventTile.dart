import 'package:flutter/material.dart';
import 'package:gather_go/Models/EventInfo.dart';

class EventTile extends StatelessWidget {
  //const EventTile({ Key? key }) : super(key: key);

  final EventInfo? event;

  EventTile({this.event});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: (8.0)),
        child: Card(
            margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
            child: ListTile(
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.purple[300],
              ),
              title: Text(event!.name),
              subtitle: Text(event!.description),
            )));
  }
}
