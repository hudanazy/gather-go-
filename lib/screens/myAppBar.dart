import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({Key? key, required this.title}) : super(key: key);
  final title;
  @override
  Widget build(BuildContext context) {
    return MyAppBarWidget(title, context);
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

Widget MyAppBarWidget(title, context) {
  return AppBar(
      title: Text(title,
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'Comfortaa',
              fontSize: 28,
              fontWeight: FontWeight.w500,
              letterSpacing: 2)),
      elevation: 4,
      toolbarHeight: 100,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      //centerTitle: true,
      actions: <Widget>[
        IconButton(
          padding: const EdgeInsets.only(right: 10), //top:22
          iconSize: 30,
          // padding: EdgeInsets.only(left: 270, top: 40),
          icon: Icon(
            Icons.logout_outlined,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
            FirebaseAuth.instance.signOut();
          },
        ),
      ]);
}

class SecondaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SecondaryAppBar({Key? key, required this.title}) : super(key: key);
  final title;
  @override
  Widget build(BuildContext context) {
    return MySecondaryAppBarWidget(title);
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

Widget MySecondaryAppBarWidget(title) {
  return AppBar(
    title: Text(title,
        style: TextStyle(
            color: Colors.black,
            fontFamily: 'Comfortaa',
            fontSize: 28,
            fontWeight: FontWeight.w500)),
    elevation: 6,
    toolbarHeight: 100,
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    //centerTitle: true,
  );
}
