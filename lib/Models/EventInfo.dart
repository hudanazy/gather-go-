import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class EventInfo {
  final String name;
  final String description;
  final String date;
  final String time;
  //final GeoPoint location;

  EventInfo(
      {required this.name,
      required this.description,
      required this.date,
      required this.time /*,
      required this.location*/
      });
}
