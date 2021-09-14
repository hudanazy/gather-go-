import 'package:flutter/material.dart';
import 'package:gather_go/services/auth.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  //final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      //home UI goes here
      
      ElevatedButton(
        child: Text('Log out'),
        onPressed: () async {
          //await _auth.SignOut();
        },
        )
    );
  }
}
