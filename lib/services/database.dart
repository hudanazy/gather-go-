import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'package:gather_go/Models/UserOnScreen.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference eventCollection =
      FirebaseFirestore.instance.collection('events');

  Future updateUserData(String name, String bio) async {
    return await userCollection.doc(uid).set({
      "name": name,
      "bio": bio,
    });
  }

  Future updateEventData(
      String title, String description, DateTime date) async {
    return await eventCollection
        .doc(uid)
        .set({"title": title, "description": description, "date": date});
  }

//get user stream
  Stream<List<UserOnScreen>?> get users {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }

  //user list from snapshot
  List<UserOnScreen> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserOnScreen(doc.get('name') ?? '', doc.get('bio') ?? '');
    }).toList();
  }

//get events stream
  Stream<QuerySnapshot?> get events {
    return eventCollection.snapshots();
  }

//get user doc stream
  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  //user data from snapshot

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: snapshot.get('uid'),
      name: snapshot.get('name'),
      bio: snapshot.get('bio'),
    );
  }
}
