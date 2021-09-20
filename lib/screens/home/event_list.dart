import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gather_go/Models/EventInfo.dart';
import 'package:provider/provider.dart';
import 'package:gather_go/screens/home/EventTile.dart';

class EventList extends StatefulWidget {
  //const EventList({Key? key}) : super(key: key);

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  @override
  Widget build(BuildContext context) {
    final events = Provider.of<List<EventInfo>?>(context) ?? [];

    // users?.forEach((user) {
    //   print(user.name);
    //   print(user.bio);
    // });

    return ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          return EventTile(event: events[index]);
        });
  }
}
