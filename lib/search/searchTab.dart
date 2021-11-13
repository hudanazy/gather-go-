import 'package:flutter/material.dart';

void main() {
  runApp(const TabBarDemo());
}

class TabBarDemo extends StatelessWidget {
  const TabBarDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.red, // outdated and has no effect to Tabbar
        // deprecated,
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            bottom: const TabBar(
              indicatorColor: Colors.orangeAccent,
              labelColor: Colors.black,
              labelStyle: TextStyle(
                fontFamily: 'Comfortaa',
                fontSize: 22,
              ),
              tabs: [
                Tab(
                  text: "Name ",
                ),
                Tab(
                  text: "Description ",
                ),
              ],
            ),
            title: TextField(
              // controller: _controller,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.orangeAccent, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                  hintText: "Search",
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Comfortaa',
                  ),
                  // suffixIcon: IconButton(
                  //   onPressed: _controller.clear,
                  //   icon: Icon(Icons.clear),
                  //   color: Colors.purple[300],
                  // ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                  )),
            ),
          ),
          body: const TabBarView(
            children: [
              Icon(Icons.directions_car),
              Icon(Icons.directions_transit),
            ],
          ),
        ),
      ),
    );
  }
}
