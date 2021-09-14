import 'package:flutter/material.dart';
import 'package:gather_go/screens/authenticate/authenticate.dart';
import 'package:gather_go/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Authenticate();
    //return either home or authenticate
  }
}
