import 'package:flutter/material.dart';
import 'package:gather_go/Models/NewUser.dart';
import 'package:gather_go/screens/authenticate/authenticate.dart';
import 'package:gather_go/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'package:gather_go/screens/admin/adminHome.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<NewUser?>(context);
    //return either home or authenticate
    if (user == null)
      return Authenticate();
    else if (user.uid ==
        "xcRDQbcyiGanYwqJOWmwhZufYbg1") //access admin home if the admin is logged in
      return adminHome();
    else
      return Home();
  }
}
