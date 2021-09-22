import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:gather_go/Models/ProfileOnScreen.dart';

class EventInfo {
  final String uid;
  final String name;
  final String description;
  final String timePosted;
  //final String imageUrl;
  final int attendees;
  //final int comments;
  final String date;
  final String time;
  //final GeoPoint location;
  bool approved = false;

  EventInfo(
      {required this.uid,
      required this.name,
      required this.description,
      required this.timePosted,
      //  required this.imageUrl,
      required this.attendees,
      // required this.comments,
      required this.date,
      required this.time,
      /*,
      required this.location*/
      required this.approved});
}
