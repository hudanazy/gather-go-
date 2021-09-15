import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final String uid;

  DatabaseService(
      {this.uid}); // if i  put required will not ba an error as uid cant be null!! , when i add it it make error in home.dart !

  // collection reference

  final CollectionReference gatherGoCollection =
      FirebaseFirestore.instance.collection('uesr');

  Future updateUesrData(String uesrname, String email, String password) async {
    return await gatherGoCollection.doc(uid).set({
      'uesrname': uesrname,
      'email': email,
      'password': password,
    });
  }

  Stream<QuerySnapshot> get users {
    return gatherGoCollection.snapshots();
  }
}
