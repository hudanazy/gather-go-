import 'package:flutter/material.dart';

import 'package:gather_go/screens/home/Brows.dart';

import 'package:gather_go/screens/home/profile_form.dart';
import 'package:gather_go/screens/home/createEvent.dart';
import 'package:gather_go/search/searchPage.dart';

import 'Brows.dart';

class MyBottomBarDemo extends StatefulWidget {
  @override
  _MyBottomBarDemoState createState() => new _MyBottomBarDemoState();
}

class _MyBottomBarDemoState extends State<MyBottomBarDemo> {
  int _pageIndex = 0;
  PageController? _pageController;

  List<Widget> tabPages = [
    HomeScreen(),

    SearchList(),

    //search(),

    createEvent(),
    ProfileForm(),
  ];

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
        // backgroundColor: Colors.white,
        selectedIconTheme: IconThemeData(color: Colors.orange[500]),
        backgroundColor: Colors.white10,
        selectedLabelStyle: TextStyle(fontFamily: 'Comfortaa'),

        selectedItemColor: Colors.orange[700],
        //unselectedItemColor: Colors.green,
        type: BottomNavigationBarType.fixed,

        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: 'Add',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
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
//   int _selectedIndex = 0;
//   int _pageIndex = 0;
//   PageController? _pageController;
//   List<GlobalKey<NavigatorState>> _navigatorKeys = [
//     GlobalKey<NavigatorState>(),
//     GlobalKey<NavigatorState>(),
//     GlobalKey<NavigatorState>(),
//     GlobalKey<NavigatorState>()
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//         onWillPop: () async {
//           final isFirstRouteInCurrentTab =
//               !await _navigatorKeys[_pageIndex].currentState!.maybePop();

//           // let system handle back button if we're on the first route
//           return isFirstRouteInCurrentTab;
//         },
//         child: Scaffold(
//           //appBar: GradientAppBar(),
//           backgroundColor: Colors.white,
//           bottomNavigationBar: BottomNavigationBar(
//             // selectedIconTheme: IconThemeData(color: Colors.deepOrange),
//             backgroundColor: Colors.grey[200],
//             selectedLabelStyle: TextStyle(fontFamily: 'Comfortaa'),

//             selectedItemColor: Colors.deepOrange[400],
//             //unselectedItemColor: Colors.green,
//             type: BottomNavigationBarType.fixed,

//             //currentIndex: _selectedIndex,
//             currentIndex: _pageIndex,
//             // onTap: onTabTapped,

//             showSelectedLabels: true,
//             showUnselectedLabels: false,
//             items: [
//               BottomNavigationBarItem(
//                 icon: Icon(
//                   Icons.home,
//                 ),
//                 label: 'Home',
//                 //backgroundColor: Colors.red,
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.search),
//                 label: 'Search',
//                 //backgroundColor: Colors.green,
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(
//                   Icons.add_box_outlined,
//                 ),
//                 label: 'Add',
//                 //backgroundColor: Colors.purple,
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(
//                   Icons.person,
//                 ),
//                 label: 'Profile',
//                 // backgroundColor: Colors.pink,
//               ),
//             ],

//             onTap: (index) {
//               onTabTapped(index);
//               setState(() {
//                 _pageIndex = index;
//               });
//             },
//           ),
//           body: Stack(
//             children: [
//               _buildOffstageNavigator(0),
//               _buildOffstageNavigator(1),
//               _buildOffstageNavigator(2),
//               _buildOffstageNavigator(3),
//             ],
//           ),
//         ));
//   }

//   void onPageChanged(int page) {
//     setState(() {
//       _pageIndex = page;
//     });
//   }

//   void onTabTapped(int index) {
//     this._pageController?.animateToPage(index,
//         duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
//   }

//   Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
//     return {
//       '/': (context) {
//         return tabPages.elementAt(index);
//       },
//     };
//   }

//   Widget _buildOffstageNavigator(int index) {
//     var routeBuilders = _routeBuilders(context, index);

//     return Offstage(
//       offstage: _pageIndex != index,
//       child: Navigator(
//         key: _navigatorKeys[index],
//         onGenerateRoute: (routeSettings) {
//           return MaterialPageRoute(
//             builder: (context) => routeBuilders[routeSettings.name]!(context),
//           );
//         },
//       ),
//     );
//   }
// }
