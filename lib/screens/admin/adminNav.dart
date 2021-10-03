import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gather_go/screens/admin/adminEvent.dart';
import 'package:gather_go/screens/home/EventTile.dart';
import 'package:gather_go/screens/home/createEvent.dart';
import 'package:gather_go/screens/home/event_list.dart';
import 'package:gather_go/screens/home/user_list.dart';
import 'package:gather_go/shared/gradient_app_bar.dart';

// ignore: camel_case_types
class adminBottomBarDemo extends StatefulWidget {
  @override
  _adminBottomBarDemoState createState() => new _adminBottomBarDemoState();
}

// ignore: camel_case_types
class _adminBottomBarDemoState extends State<adminBottomBarDemo> {
//   int _pageIndex = 0;
//   PageController? _pageController;
//   int _selectedIndex = 0;

//   List<Widget> _widgetOptions = [
//     adminEvent(),
//     Text('data'),
//     logout()
//   ]; //EventList()

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController(initialPage: _pageIndex);
//   }

//   @override
//   void dispose() {
//     _pageController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: onTabTapped,

//         showSelectedLabels: false,
//         showUnselectedLabels: false,
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Events',
//             backgroundColor: Colors.red,
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.comment),
//             label: 'Comments',
//             backgroundColor: Colors.green,
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.logout),
//             label: 'Log Out',
//             backgroundColor: Colors.pink,
//           )
//         ],
//         // onTap: (index) {
//         //   setState(() {
//         //     _selectedIndex = index;
//         //   });
//         // },
//       ),
//       body: PageView(
//         children: [
//           _buildOffstageNavigator(0),
//           _buildOffstageNavigator(1),
//           _buildOffstageNavigator(2),
//         ],
//         onPageChanged: onPageChanged,
//         controller: _pageController,
//       ),
//     );
//   }

//   void onPageChanged(int page) {
//     setState(() {
//       this._pageIndex = page;
//     });
//   }

//   void onTabTapped(int index) {
//     this._pageController?.animateToPage(index,
//         duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
//   }

//   Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
//     return {
//       '/': (context) {
//         return [adminEvent(), Text('data'), logout()].elementAt(index);
//       },
//     };
//   }

//   Widget _buildOffstageNavigator(int index) {
//     var routeBuilders = _routeBuilders(context, index);

//     return Offstage(
//       offstage: _selectedIndex != index,
//       child: Navigator(
//         onGenerateRoute: (routeSettings) {
//           return MaterialPageRoute(
//             builder: (context) => routeBuilders[routeSettings.name]!(context),
//           );
//         },
//       ),
//     );
//   }
// }
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
          //appBar: GradientAppBar(),
          backgroundColor: Colors.white,
          bottomNavigationBar: BottomNavigationBar(
            //currentIndex: _selectedIndex,
            currentIndex: _pageIndex,
            // onTap: onTabTapped,

            showSelectedLabels: true,
            showUnselectedLabels: false,
            items: [
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
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.logout),
              //   label: 'Log Out',
              //   backgroundColor: Colors.pink,
              // )
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
        return [
          adminEvent(),
          Text('data'),
        ].elementAt(index);
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
}

// ignore: camel_case_types
class logout extends StatelessWidget {
  const logout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
        },
        child: Text('logout'),
      ),
    );
  }
}
// res https://medium.com/@theboringdeveloper/common-bottom-navigation-bar-flutter-e3693305d2d