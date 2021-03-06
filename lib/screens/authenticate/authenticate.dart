import 'package:flutter/material.dart';
import 'package:gather_go/screens/authenticate/register.dart';
import 'package:gather_go/screens/authenticate/sign_in.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView);
    } else {
      return Register(toggleView);
    }

    // return Scaffold(
    //   body: Column(
    //     children: [
    //       ElevatedButton(
    //         child: Text('Register'),
    //         onPressed: () {
    //           Navigator.push(
    //               context,
    //               MaterialPageRoute(
    //                   builder: (context) =>
    //                       Register())); //https://flutter.dev/docs/cookbook/navigation/navigation-basics
    //         },
    //       ),
    //       ElevatedButton(
    //         child: Text('Login'),
    //         onPressed: () {
    //           Navigator.push(
    //               context,
    //               MaterialPageRoute(
    //                   builder: (context) =>
    //                       SignIn())); //https://flutter.dev/docs/cookbook/navigation/navigation-basics
    //         },
    //       ),
    //     ],
    //   ),
    // );
  }
}
