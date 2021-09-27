import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  Future updateEventData(String? title, String? description, String? date,
      String? time /*, GeoPoint location*/, bool approved) async {
    return await eventCollection.doc(uid).set({
      "title": title,
      "description": description,
      "date": date,
      "time": time,
      "approved": approved,
      /* "location": location*/
    }); // may need to change date and time format
  }

  Future approveEvent(bool approved) async {
    eventCollection.add({
      'adminCheck': true,
    });
    return await eventCollection.doc(uid).set({
      "approved": approved,
    });
  }

  addEventData(String title, String description, Timestamp date,
      Timestamp time /*, GeoPoint location*/, bool approved) {
    eventCollection.add({
      "name": title, // dont call it title (in firestore)
      "description": description,
      "date": date,
      "time": time,
      "approved": approved,
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
      return ProfileOnScreen(doc.get('name') ?? '', doc.get('bio') ?? '');
    }).toList();
  }

//get events stream
  Stream<EventInfo> get events {
    return eventCollection.doc(uid).snapshots().map(_eventDataFromSnapshot);
  }

  Stream<List<EventInfo>> get eventss {
    // return profileCollection.snapshots().map(_eventInfoListFromSnapshot);
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
    );
  }

  EventInfo _eventDataFromSnapshot(DocumentSnapshot snapshot) {
    return EventInfo(
      //  uid: snapshot.get('uid'),
      name: snapshot.get('name'),
      description: snapshot.get('description'),
      date: snapshot.get('date'),
      time: snapshot.get('time'),
      approved: snapshot.get('approved'),
    );
  }

  Future updateUesrData(String uesrname, String email, String password) async {
    return await userCollection.doc(uid).set({
      'uesrname': uesrname,
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
        name: doc.get('name') ?? '',
        description: doc.get('description') ?? '',
        date: doc.get('date') ?? '',
        time: doc.get('time') ?? '',
        approved: doc.get('approved') ?? '',
        /* location: doc.get('location') ?? ''*/
      );
    }).toList();
  }
}
