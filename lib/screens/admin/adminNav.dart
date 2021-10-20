import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gather_go/screens/admin/adminEvent.dart';
import 'package:gather_go/screens/home/EventTile.dart';
import 'package:gather_go/screens/home/createEvent.dart';
import 'package:gather_go/screens/home/event_list.dart';
import 'package:gather_go/screens/home/user_list.dart';
import 'package:gather_go/shared/dialogs.dart';
import 'package:gather_go/shared/gradient_app_bar.dart';

// ignore: camel_case_types
class adminBottomBarDemo extends StatefulWidget {
  @override
  _adminBottomBarDemoState createState() => new _adminBottomBarDemoState();
}

// ignore: camel_case_types
class _adminBottomBarDemoState extends State<adminBottomBarDemo> {
  int _selectedIndex = 0;
  int _pageIndex = 0;
  PageController? _pageController;
  List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    // GlobalKey<NavigatorState>(),
    // GlobalKey<NavigatorState>()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          final isFirstRouteInCurrentTab =
              !await _navigatorKeys[_pageIndex].currentState!.maybePop();

          // let system handle back button if we're on the first route
          return isFirstRouteInCurrentTab;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _pageIndex,
            backgroundColor: Colors.grey[200],
            selectedLabelStyle: TextStyle(fontFamily: 'Comfortaa'),
            selectedItemColor: Colors.deepOrange[400],
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Events',
                //backgroundColor: Colors.red,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.comment),
                label: 'Comments',
                // backgroundColor: Colors.green,
              )
            ],
            onTap: (index) {
              onTabTapped(index);
              setState(() {
                _pageIndex = index;
                _pageController?.animateToPage(index,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut);
              });
            },
          ),
          body: Stack(
            children: [
              _buildOffstageNavigator(0),
              _buildOffstageNavigator(1),
              // _buildOffstageNavigator(2),
              //_buildOffstageNavigator(3),
            ],
          ),
        ));
  }

  void onPageChanged(int page) {
    setState(() {
      _pageIndex = page;
    });
  }

  void onTabTapped(int index) {
    _pageController?.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    return {
      '/': (context) {
        return [adminEvent(), Text('data')].elementAt(index);
      },
    };
  }

  Widget _buildOffstageNavigator(int index) {
    var routeBuilders = _routeBuilders(context, index);

    return Offstage(
      offstage: _pageIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => routeBuilders[routeSettings.name]!(context),
          );
        },
      ),
    );
  }

  // Future<Widget> logOutdialog() async {
  //   var result = await logOutAdminDialog(context);
  //   if (result == true) {
  //     await FirebaseAuth.instance.signOut();
  //   }
  //   return Text('data');
  // }
}

// ignore: camel_case_types
class logout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
        },
        icon: Icon(Icons.logout, color: Colors.deepOrange),
        label: Text('Log Out',
            style: TextStyle(
              color: Colors.deepOrange,
            )),
        style: ElevatedButton.styleFrom(
          primary: Colors.red,
        ));
  }
}
// res https://medium.com/@theboringdeveloper/common-bottom-navigation-bar-flutter-e3693305d2d