import 'package:firebase_auth/firebase_auth.dart';
import 'package:gather_go/Models/NewUser.dart';

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
    return _auth.authStateChanges()
    .map((User? user) => _userInfoFromFirebaseUser(user));
  }

//getting a user from the firebase user
  NewUser? _userInfoFromFirebaseUser(User? user){
      if (user != null) return NewUser(uid: user.uid);
      else return null;
      
  }
//sign in anonymously method
//sign in w/ email password
Future SignInWithUsernameAndPassword(String username, String password) async{
  try {
    UserCredential result = await _auth.signInWithEmailAndPassword(email: username, password: password);
    User? user = result.user;
    return _userInfoFromFirebaseUser(user);
  }
  catch (e) {
    print(e.toString());
    return null;
  }
}
//register
//sign out

}
