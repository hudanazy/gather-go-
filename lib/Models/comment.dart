import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String? text;
  Object? uid;
  DocumentSnapshot<Object?>? eventID;
  int? likes;
  int? dislikes;
  String timePosted;

  Comment(
      {required this.text,
      required this.uid,
      required this.eventID,
      required this.likes,
      required this.dislikes,
      required this.timePosted});
}
