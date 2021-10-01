import 'package:flutter/material.dart';

import 'package:gather_go/screens/admin/adminNav.dart';

// to be added to adminHome.dart
class adminHome extends StatefulWidget {
  adminHome({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<adminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: adminBottomBarDemo(),
    );
  }
}
