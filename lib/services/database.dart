import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gather_go/Models/UesrInfo.dart';
import 'package:gather_go/Models/EventInfo.dart';
import 'package:gather_go/Models/ProfileOnScreen.dart';
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

  Future updateProfileData(String uid, String name, String status, String bio,
      String imageUrl) async {
    return await userCollection.doc(uid).set({
      "uid": uid,
      "name": name,
      "bio": bio,
      "status": status,
      "imageUrl": imageUrl,
      "bookedEvents": FirebaseFirestore.instance.collection('bookedEvents'),
    });
  }

  Future disapproveEvent(
      String? userID,
      String? name,
      String? description,
      String? timePosted,
      int? attendeeNum,
      String? date,
      String? time,
      String? category,
      double? lat,
      double? long) async {
    return await eventCollection.doc(uid).set({
      "uid": userID,
      "name": name,
      "description": description,
      "timePosted": timePosted,
      "attendees": attendeeNum,
      "bookedNumber": 0,
      "date": date,
      "time": time,
      "category": category,
      'approved': false,
      "adminCheck": true,
      "lat": lat,
      "long": long,
    });
  }

  Future approveEvent(
      String? userID,
      String? name,
      String? description,
      String? timePosted,
      int? attendeeNum,
      String? date,
      String? time,
      String? category,
      double? lat,
      double? long) async {
    return await eventCollection.doc(uid).set({
      "uid": userID,
      "name": name,
      "description": description,
      "timePosted": timePosted,
      "attendees": attendeeNum,
      "bookedNumber": 0,
      "date": date,
      "time": time,
      "category": category,
      'approved': true,
      "adminCheck": true,
      "lat": lat,
      "long": long,
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
  ) {
    eventCollection.add({
      "uid": uid,
      "name": name,
      "category": category,
      "description": description,
      "timePosted": timePosted,
      "attendees": attendees,
      "bookedNumber": 0,
      "date": date,
      "time": time,
      "approved": approved,
      "adminCheck": adminCheck,
      "lat": lat,
      "long": long,
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
      "bookedEvents": FirebaseFirestore.instance.collection('bookedEvents'),
      /* "location": location*/
    }); // may need to change date and time format
  }

    //user booked events

  addBookedEventToProfile(
    String eventUid
    ) {
    userCollection.doc(FirebaseAuth.instance.currentUser!.uid).collection('bookedEvents').doc(eventUid).set({
      "eventUid": eventUid,
    });
  }

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
    );
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
          adminCheck: doc.get('adminCheck') ?? '');
    }).toList();
  }
}
