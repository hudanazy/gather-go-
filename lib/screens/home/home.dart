import 'package:flutter/material.dart';
import 'package:gather_go/Models/UesrInfo.dart';
import 'package:gather_go/services/auth.dart';
import 'package:gather_go/services/database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gather_go/screens/home/uesr_list.dart';

class Home extends StatelessWidget {
  //const Home({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();
// Widget build(BuildContext context) {
//     return Provider<Example>(
//       create: (_) => Example(),
//       // we use `builder` to obtain a new `BuildContext` that has access to the provider
//       builder: (context) {
//         // No longer throws
//         return Text(context.watch<Example>()),
//       }
//     ),
//   }
  final uesrList initial = uesrList();
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<UesrInfo>>.value(
      //
      initialData: [],
      value: DatabaseService(uid: '')
          .users, // we must add uid but i dont know how??
      // i realy dont know what to put here !!
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            ElevatedButton(
              child: Text('Log out'),
              onPressed: () async {
                await _auth.SignOut();
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
