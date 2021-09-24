import 'package:flutter/material.dart';
import 'package:gather_go/screens/admin/adminEvent.dart';
import 'package:gather_go/screens/home/EventTile.dart';
import 'package:gather_go/screens/home/createEvent.dart';
import 'package:gather_go/screens/home/event_list.dart';
import 'package:gather_go/screens/home/user_list.dart';

// ignore: camel_case_types
class adminBottomBarDemo extends StatefulWidget {
  @override
  _adminBottomBarDemoState createState() => new _adminBottomBarDemoState();
}

// ignore: camel_case_types
class _adminBottomBarDemoState extends State<adminBottomBarDemo> {
  int _pageIndex = 0;
  PageController? _pageController;

  List<Widget> tabPages = [
    adminEvent(),
    Text("shhhhhhahah"),
    Text("shhhhhhahah")
  ]; //EventList()

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        onTap: onTabTapped,
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Events',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.comment),
            label: 'Comments',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Log Out',
            backgroundColor: Colors.pink,
          ),
        ],
      ),
      body: PageView(
        children: tabPages,
        onPageChanged: onPageChanged,
        controller: _pageController,
      ),
    );
  }

  void onPageChanged(int page) {
    setState(() {
      this._pageIndex = page;
    });
  }

  void onTabTapped(int index) {
    this._pageController?.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }
}
