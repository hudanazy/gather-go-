import 'package:cloud_firestore/cloud_firestore.dart';

class EventInfo {
  final String name;
  final String description;
  final DateTime date;
  final GeoPoint location;

  EventInfo(
      {required this.name,
      required this.description,
      required this.date,
      required this.location});
}
