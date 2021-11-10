import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String? text;
  String? uid;
  DocumentSnapshot<Object?>? eventID;
  int? likes;
  int? dislikes;

  Comment(
      {required this.text,
      required this.uid,
      required this.eventID,
      required this.likes,
      required this.dislikes});
}
