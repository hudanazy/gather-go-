import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:gather_go/Models/UesrInfo.dart';
import 'package:gather_go/Models/EventInfo.dart';

import 'package:gather_go/Models/ProfileOnScreen.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference profileCollection =
      FirebaseFirestore.instance.collection('profiles');

  final CollectionReference eventCollection =
      FirebaseFirestore.instance.collection('events');
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('uesrInfo');

  Future updateProfileData(String name, String bio) async {
    return await profileCollection.doc(uid).set({
      "name": name,
      "bio": bio,
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
      "date": date,
      "time": time,
      "approved": approved,
      "adminCheck": adminCheck,
      "lat": lat,
      "long": long,
    }); // may need to change date and time format
  }

  addProfileData(
    String uid,
    String name,
    String bio,
    String email,
    String imageUrl,
  ) {
    profileCollection.add({
      "uid": uid,
      "name": name,
      "bio": bio,
      "email": email,
      "imageUrl": imageUrl,

      /* "location": location*/
    }); // may need to change date and time format
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

//get user doc stream
  Stream<ProfileData> get profileData {
    return profileCollection.doc(uid).snapshots().map(_profileDataFromSnapshot);
  }

  //user data from snapshot

  ProfileData _profileDataFromSnapshot(DocumentSnapshot snapshot) {
    return ProfileData(
      uid: snapshot.get('uid'),
      name: snapshot.get('name'),
      bio: snapshot.get('bio'),
      email: snapshot.get('email') ?? '',
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
      // adminCheck: snapshot.get('adminCheck'),
    );
  }

  Future updateUesrData(String uesrname, String email, String password) async {
    return await userCollection.doc(uid).set({
      'name': uesrname,
      'email': email,
      'password': password,
    });
  }

  Stream<List<UesrInfo>> get users {
    return userCollection.snapshots().map(_userInfoListFromSnapshot);
  }

  //uesr list from snopshot
  List<UesrInfo> _userInfoListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UesrInfo(
          // snapshot.data['uesrname']
          uesrname: doc.get('uesrname') ?? '',
          email: doc.get('email') ?? '',
          password: doc.get('password') ?? '');
    }).toList();
  }

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
        //adminCheck: doc.get('adminCheck') ?? ''
      );
    }).toList();
  }
}
