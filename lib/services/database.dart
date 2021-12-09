import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gather_go/Models/UesrInfo.dart';
import 'package:gather_go/Models/EventInfo.dart';
import 'package:gather_go/Models/ProfileOnScreen.dart';
//import 'package:gather_go/Models/comment.dart';
import 'dart:io';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference profileCollection =
      FirebaseFirestore.instance.collection('profiles');

  final CollectionReference eventCollection =
      FirebaseFirestore.instance.collection('events');
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('uesrInfo');
  final CollectionReference commentCollection =
      FirebaseFirestore.instance.collection('comments');

  Future updateProfileData(String uid, String name, String status, String bio,
      String imageUrl) async {
    List<String> searchName =
        []; //https://stackoverflow.com/questions/50870652/flutter-firebase-basic-query-or-basic-search-code
    String temp = "";
    for (var i = 0; i < name.length; i++) {
      if (name[i] == " ") {
        temp = "";
      } else {
        temp = temp + name[i];
        searchName.add(temp.toLowerCase());
      }
    }
    return await userCollection.doc(uid).set({
      "uid": uid,
      "name": name,
      "bio": bio,
      "status": status,
      "imageUrl": imageUrl,
      "searchName": searchName
      //"bookedEvents": FirebaseFirestore.instance.collection('bookedEvents'),
    });
  }

  Future? disapproveEvent() async {
    return await eventCollection.doc(uid).update({
      'approved': false,
      "adminCheck": true,
    });
  }

  Future? approveEvent() async {
    return await eventCollection.doc(uid).update({
      'approved': true,
      "adminCheck": true,
    });
  }

  Future disapproveEvent2(
      String? userID,
      String? name,
      String? description,
      String? timePosted,
      int? attendeeNum,
      String? date,
      String? time,
      String? category,
      double? lat,
      double? long,
      DateTime browseDate) async {
    List<String> searchDescription = [];
    String temp = "";
    for (var i = 0; i < description!.length; i++) {
      if (description[i] == " ") {
        temp = "";
      } else {
        temp = temp + description[i];
        searchDescription.add(temp.toLowerCase());
      }
    }
    List<String> nameLowerCase = [];

    temp = "";
    for (var i = 0; i < name!.length; i++) {
      if (name[i] == " ") {
        temp = "";
      } else {
        temp = temp + name[i];
        nameLowerCase.add(temp.toLowerCase());
      }
    }

    return await eventCollection.doc(uid).set({
      "uid": userID,
      "name": name,
      "description": description,
      "timePosted": timePosted,
      "attendees": attendeeNum,
      "bookedNumber": 0,
      "attendeesList": [],
      "date": date, //DateTime.parse(date!),
      "time": time, //DateTime.parse(time!),
      "category": category,
      'approved': false,
      "adminCheck": true,
      "lat": lat,
      "long": long,
      "nameLowerCase": nameLowerCase,
      "searchDescription": searchDescription,
      "browseDate": browseDate,
    });
  }

  Future approveEvent2(
      String? userID,
      String? name,
      String? description,
      String? timePosted,
      int? attendeeNum,
      String? date,
      String? time,
      String? category,
      double? lat,
      double? long,
      DateTime browseDate) async {
    List<String> searchDescription = [];
    String temp = "";

    for (var i = 0; i < description!.length; i++) {
      if (description[i] == " ") {
        temp = "";
      } else {
        temp = temp + description[i];
        searchDescription.add(temp.toLowerCase());
      }
    }
    List<String> nameLowerCase = [];

    temp = "";
    for (var i = 0; i < name!.length; i++) {
      if (name[i] == " ") {
        temp = "";
      } else {
        temp = temp + name[i];
        nameLowerCase.add(temp.toLowerCase());
      }
    }
    return await eventCollection.doc(uid).set({
      "uid": userID,
      "name": name,
      "description": description,
      "timePosted": timePosted,
      "attendees": attendeeNum,
      "bookedNumber": 0,
      "attendeesList": [],
      "date": date,
      "time": time,
      "category": category,
      'approved': true,
      "adminCheck": true,
      "lat": lat,
      "long": long,
      "nameLowerCase": nameLowerCase,
      "searchDescription": searchDescription,
      "browseDate": browseDate,
    });
  }

  addCommentData(String text, String uid, String name, String imageUrl,
      String eventID, int likes, List likeList, DateTime timePosted) {
    commentCollection.add({
      "text": text,
      "uid": uid,
      "name": name,
      "imageUrl": imageUrl,
      "eventID": eventID,
      "likes": likes,
      "likeList": likeList,
      "timePosted": timePosted,
      "userReported": [],
      "reportNumber": 0
    });
  }

  addEventData(
      String uid,
      String name,
      String category,
      String description,
      String timePosted,
      int attendees,
      String date,
      String time,
      bool approved,
      bool adminCheck,
      double lat,
      double long,
      String image,
      DateTime browseDate) {
    List<String> searchDescription =
        []; //https://stackoverflow.com/questions/50870652/flutter-firebase-basic-query-or-basic-search-code
    String temp = "";
    for (var i = 0; i < description.length; i++) {
      if (description[i] == " ") {
        temp = "";
      } else {
        temp = temp + description[i];
        searchDescription.add(temp.toLowerCase());
      }
    }
    List<String> nameLowerCase = [];

    temp = "";
    for (var i = 0; i < name.length; i++) {
      if (name[i] == " ") {
        temp = "";
      } else {
        temp = temp + name[i];
        nameLowerCase.add(temp.toLowerCase());
      }
    }
    Random random = new Random();
    int eventID = random.nextInt(90) + 1000;
    eventCollection.add({
      "uid": uid,
      "name": name,
      "category": category,
      "description": description,
      "timePosted": timePosted,
      "attendees": attendees,
      "bookedNumber": 0,
      "attendeesList": [],
      "date": date,
      "time": time,
      "approved": approved,
      "adminCheck": adminCheck,
      "lat": lat,
      "long": long,
      "nameLowerCase": nameLowerCase,
      "searchDescription": searchDescription,
      "imageUrl": image,
      "browseDate": browseDate,
      "eventID": eventID
    });
  }

  addProfileData(
    String uid,
    String name,
    String bio,
    String email,
    String status,
    File imageUrl,
  ) {
    profileCollection.add({
      "uid": uid,
      "name": name,
      "bio": bio,
      "email": email,
      "status": status,
      "imageUrl": imageUrl,
      //"bookedEvents": FirebaseFirestore.instance.collection('bookedEvents'),
      /* "location": location*/
    }); // may need to change date and time format
  }

  //user booked events

  // addBookedEventToProfile(
  //   String eventUid
  //   ) {
  //   userCollection.doc(FirebaseAuth.instance.currentUser!.uid).collection('bookedEvents').doc(eventUid).set({
  //     "eventUid": eventUid,
  //   });
  // }

//get user stream
  Stream<List<ProfileOnScreen>?> get profiles {
    return profileCollection.snapshots().map(_profileListFromSnapshot);
  }

  //user list from snapshot
  List<ProfileOnScreen> _profileListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return ProfileOnScreen(
        name: doc.get('name') ?? '',
        bio: doc.get('bio') ?? '',
        email: doc.get('email') ?? '',
        imageUrl: doc.get('imageUrl') ?? '',
      );
    }).toList();
  }

//get events stream
  Stream<EventInfo> get eventss {
    return eventCollection.doc(uid).snapshots().map(_eventDataFromSnapshot);
    //  return eventCollection.doc(uid).snapshots().map(_eventDataFromSnapshot);
  }

  Stream<List<EventInfo>> get events {
    return eventCollection.snapshots().map(_eventInfoListFromSnapshot);
  }

//get profile doc stream
  Stream<UesrInfo> get profileData {
    return userCollection.doc(uid).snapshots().map(_profileDataFromSnapshot);
  }

  //profile data from snapshot

  UesrInfo _profileDataFromSnapshot(DocumentSnapshot snapshot) {
    return UesrInfo(
      uid: snapshot.get('uid') ?? '',
      name: snapshot.get('name') ?? '',
      bio: snapshot.get('bio') ?? '',
      email: snapshot.get('email') ?? '',
      status: snapshot.get('status') ?? '',
      imageUrl: snapshot.get('imageUrl') ?? '',
    );
  }

  EventInfo _eventDataFromSnapshot(DocumentSnapshot snapshot) {
    return EventInfo(
        //  uid: snapshot.get('uid'),
        uid: snapshot.get('uid'),
        name: snapshot.get('name'),
        category: snapshot.get('category'),
        description: snapshot.get('description'),
        timePosted: snapshot.get('timePosted'),
        //  imageUrl: snapshot.get('imageUrl'),
        attendees: snapshot.get('attendees'),
        // comments: snapshot.get('comments'),
        date: snapshot.get('date'),
        time: snapshot.get('time'),
        approved: snapshot.get('approved'),
        adminCheck: snapshot.get('adminCheck'),
        imageUrl: snapshot.get("imageUrl"),
        browseDate: snapshot.get("browseDate"));
  }

  Future updateUesrData(
    String name,
    String email, // String password
  ) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'email': email,
      //'password': password,
    });
  }

  /* Stream<List<UesrInfo>> get users {
    return userCollection.snapshots().map(_userInfoListFromSnapshot);
  }*/

  //uesr list from snopshot
  /*List<UesrInfo> _userInfoListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UesrInfo(
          // snapshot.data['uesrname']
          name: doc.get('name') ?? '',
          email: doc.get('email') ?? '',
          password: doc.get('password') ?? '');
        // snapshot.data['uesrname']
        name: doc.get('name') ?? '',
        email: doc.get('email') ?? '',
        // password: doc.get('password') ?? ''
      );
    }).toList();
  }*/

  List<EventInfo> _eventInfoListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return EventInfo(
          // snapshot.data['uesrname']
          uid: doc.get('uid') ?? '',
          name: doc.get('name') ?? '',
          category: doc.get('category') ?? '',
          description: doc.get('description') ?? '',
          timePosted: doc.get('timePosted') ?? '',
          // imageUrl: doc.get('imageUrl') ?? '',
          attendees: doc.get('attendees') ?? 0,
          // comments: doc.get('comments') ?? 0,
          date: doc.get('date') ?? '',
          time: doc.get('time') ?? '',
          /* location: doc.get('location') ?? ''*/
          approved: doc.get('approved') ?? '',
          adminCheck: doc.get('adminCheck') ?? '',
          imageUrl: doc.get('imageUrl') ?? '',
          browseDate: doc.get('browseDate') ?? '');
    }).toList();
  }
}
