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

//sign in anonymously method
//sign in w/ email password
  Future SignInWithUsernameAndPassword(String username, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: username, password: password);
      User? user = result.user;
      return _userInfoFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

//register user name email password
  Future registerWithEmailAndUsernameAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      // create a new doc for the uesr with the uid
      // tutorial write damy data
      await DatabaseService(uid: user!.uid)
          .updateUesrData("shahad", email, password);
      return _userInfoFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

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
