import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'package:gather_go/Models/ProfileOnScreen.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference profileCollection =
      FirebaseFirestore.instance.collection('profiles');
  final CollectionReference eventCollection =
      FirebaseFirestore.instance.collection('events');

  Future updateProfileData(String name, String bio) async {
    return await profileCollection.doc(uid).set({
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
  Stream<QuerySnapshot?> get events {
    return eventCollection.snapshots();
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
}
