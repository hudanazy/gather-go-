import 'package:flutter/material.dart';
import 'package:gather_go/Models/NewUser.dart';
import 'package:gather_go/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gather_go/services/auth.dart';
import 'package:provider/provider.dart';
import 'Models/NewUser.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

void main() async {
  // These two lines
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //
  runApp(MyApp());
}

/// This is the main application widget.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<NewUser?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        home: AnimatedSplashScreen(
          //Wrapper(),
          splash: Image.asset(
            'images/logo.PNG',
          ),
          splashIconSize: 490.0,
          splashTransition: SplashTransition.fadeTransition,
          nextScreen: Wrapper(),
          duration: 2500,
        ),
      ),
    );
  }
}
