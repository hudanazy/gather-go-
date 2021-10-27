//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gather_go/Models/NewUser.dart';
import 'package:gather_go/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userInfoFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //auth change stream
  Stream<NewUser?> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userInfoFromFirebaseUser(user));
  }

//getting a user from the firebase user
  NewUser? _userInfoFromFirebaseUser(User? user) {
    if (user != null)
      return NewUser(uid: user.uid);
    else
      return null;
  }

//sign in with email and password
  Future signInWithUsernameAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userInfoFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

//sign up w/ email password
  Future signUpWithUsernameAndPassword(
      String name, String emial, String password, String Confirm) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: emial, password: password);
      User? user = result.user;

      //create a new document for a user with uid
      await DatabaseService(uid: user!.uid).updateProfileData(
          user.uid,
          name,
          "Available",
          "I'm new here!",
          "https://picsum.photos/200/300" //password
          );

      return _userInfoFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  /* Future<bool> UsernameCheck(String username) async {
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    return result.docs.isEmpty;
  } */
  //check

  //   Future createEvent(String title, String description, DateTime date) async {
  //   try {

  //     await DatabaseService()
  //           .updateEventData("Bowling", "Indoors", DateTime.now());

  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

//register
//sign out
  Future SignOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
