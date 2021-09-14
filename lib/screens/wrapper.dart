import 'package:flutter/material.dart';
import 'package:gather_go/Models/NewUser.dart';
import 'package:gather_go/screens/authenticate/authenticate.dart';
import 'package:gather_go/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user= Provider.of<NewUser?>(context);

    //return either home or authenticate
    if (user == null)
      return Authenticate();
    else return Home();
  }
}
