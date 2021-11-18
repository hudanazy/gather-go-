import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String? text;
  Object? uid;
  Object? name;
  Object? imageUrl;
  DocumentSnapshot<Object?>? eventID;
  int? likes;
  int? dislikes;
  DateTime timePosted;

  Comment(
      {required this.text,
      required this.uid,
      required this.name,
      required this.imageUrl,
      required this.eventID,
      required this.likes,
      required this.dislikes,
      required this.timePosted});
}
