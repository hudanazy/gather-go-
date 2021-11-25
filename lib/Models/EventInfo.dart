class EventInfo {
  final String uid;
  final String name;
  final String category;
  final String description;
  final String timePosted;
  //final String imageUrl;
  final int attendees;
  //final int comments;
  final String date;
  final String time;
  //final GeoPoint location;
  bool approved = false;
  bool adminCheck = false;
  final String imageUrl;
  //int attendeeNumber;

  EventInfo(
      {required this.uid,
      required this.name,
      required this.category,
      required this.description,
      required this.timePosted,
      //  required this.imageUrl,
      required this.attendees,
      // required this.comments,
      required this.date,
      required this.time,
      /*,
      required this.location*/
      required this.approved,
      required this.adminCheck,
      required this.imageUrl
      // required this.attendeeNumber,
      });
}
