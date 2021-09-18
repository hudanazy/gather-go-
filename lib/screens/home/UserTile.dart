import 'package:flutter/material.dart';
import 'package:gather_go/Models/ProfileOnScreen.dart';

class UserTile extends StatelessWidget {
  //const UserTile({ Key? key }) : super(key: key);
  final ProfileOnScreen? user;

  UserTile({this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: (8.0)),
        child: Card(
            margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
            child: ListTile(
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.purple[300],
              ),
              title: Text(user!.name),
              subtitle: Text(user!.bio),
            )));
  }
}
