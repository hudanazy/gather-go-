import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SearchAppBar(),
    );
  }
}

class SearchAppBar extends StatefulWidget {
  @override
  _SearchAppBarState createState() => new _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  Widget appBarTitle = new Text('\nSearch for events',
      style: TextStyle(
          color: Colors.black, fontFamily: 'Comfortaa', fontSize: 24));
  Icon actionIcon = new Icon(Icons.search, color: Colors.black, size: 40);
  TabBar tabs = TabBar(
    tabs: [],
  );
  int tabNum = 0;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: tabNum,
        child: Scaffold(
          appBar: new AppBar(
              backgroundColor: Colors.white,
              centerTitle: false,
              bottom: tabs,
              title: appBarTitle,
              actions: <Widget>[
                new IconButton(
                  //iconSize: 40,
                  icon: actionIcon,
                  onPressed: () {
                    setState(() {
                      if (this.actionIcon.icon == Icons.search) {
                        tabNum = 2;

                        this.tabs = new TabBar(
                          indicatorColor: Colors.orangeAccent,
                          labelColor: Colors.black,
                          labelStyle: TextStyle(
                            fontFamily: 'Comfortaa',
                            fontSize: 22,
                          ),
                          tabs: [
                            Tab(
                              text: "Name",
                            ),
                            Tab(
                              text: "Description",
                            ),
                          ],
                        );
                        this.actionIcon = new Icon(Icons.cancel,
                            color: Colors.black, size: 27);
                        this.appBarTitle = TextField(
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 15),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.orangeAccent, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2),
                              ),
                              hintText: "Search",
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Comfortaa',
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.black,
                              )),
                        );
                      } else {
                        tabNum = 0;
                        this.tabs = new TabBar(
                          indicatorColor: Colors.orangeAccent,
                          labelColor: Colors.black,
                          labelStyle: TextStyle(
                            fontFamily: 'Comfortaa',
                            fontSize: 22,
                          ),
                          tabs: [],
                        );
                        this.actionIcon = new Icon(Icons.search,
                            color: Colors.black, size: 40);
                        this.appBarTitle = new Text('\nSearch for events',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Comfortaa',
                                fontSize: 24));
                        //   // controller: _controller,
                        //   decoration: InputDecoration(
                        //       contentPadding:
                        //           EdgeInsets.symmetric(vertical: 15),
                        //       focusedBorder: OutlineInputBorder(
                        //         borderSide: BorderSide(
                        //             color: Colors.orangeAccent, width: 2),
                        //       ),
                        //       enabledBorder: OutlineInputBorder(
                        //         borderSide:
                        //             BorderSide(color: Colors.black, width: 2),
                        //       ),
                        //       hintText: "Search",
                        //       hintStyle: TextStyle(
                        //         color: Colors.black,
                        //         fontFamily: 'Comfortaa',
                        //       ),
                        //       prefixIcon: Icon(
                        //         Icons.search,
                        //         color: Colors.black,
                        //       )),
                        // );
                      }
                    });
                  },
                ),
              ]),
        ));
  }
}
