import 'package:flutter/material.dart';
import 'package:gather_go/services/auth.dart';
import 'package:gather_go/services/database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gather_go/screens/home/uesr_list.dart';

class Home extends StatelessWidget {
  //const Home({Key? key}) : super(key: key);

  //final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot>.value( //
      value: DatabaseService().users, // we must add uid but i dont know how??
      initialData:  , // i realy dont know what to put here !!
      child: Scaffold(
          appBar: AppBar(
        actions: <Widget>[
          ElevatedButton(
            child: Text('Log out'),
            onPressed: () async {
              // await _auth.SignOut();
            },
          ),
        ],
      ),
         //h

          body: uesrList(), 

          ),
    );
  }
}
