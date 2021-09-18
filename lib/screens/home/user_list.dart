import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:gather_go/Models/UserOnScreen.dart';
import 'package:gather_go/screens/home/UserTile.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<UserOnScreen>?>(context) ?? [];

    // users?.forEach((user) {
    //   print(user.name);
    //   print(user.bio);
    // });

    return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return UserTile(user: users[index]);
        });
  }
}
