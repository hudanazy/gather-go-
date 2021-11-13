import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gather_go/Models/NewUser.dart';

import 'package:gather_go/shared/loading.dart';
import 'package:provider/provider.dart';

import '../screens/home/MyEventsByCategory.dart';
import '../screens/home/eventDetailsForUsers.dart';

class SearchList extends StatefulWidget {
  // final String searchInput;
  // SearchList({required this.searchInput});
  @override
  _SearchListState createState() => new _SearchListState();
}

class _SearchListState extends State<SearchList> {
  bool isNotSearching = true;
  String searchInput = "";
  Color backColor = Colors.orange.shade100;
  Widget appBarTitle = new Text('\nSearch for events',
      style: TextStyle(
          color: Colors.black, fontFamily: 'Comfortaa', fontSize: 24));
  Icon actionIcon = new Icon(Icons.search, color: Colors.black, size: 40);
  TabBar tabs = TabBar(
    tabs: [],
  );
  int tabNum = 0;
  // String searchInput = "h";
  @override // mey move search bar to the appBar
  Widget build(BuildContext context) {
    final user = Provider.of<NewUser?>(context, listen: false);
    String? UId = user?.uid;

    var _controller = TextEditingController();
    return MaterialApp(
        home: DefaultTabController(
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
                            isNotSearching = false;
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
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2),
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
                              onChanged: (val) {
                                setState(() {
                                  searchInput = val;
                                });
                              },
                            );
                          } else {
                            searchInput = "";
                            tabNum = 0;
                            isNotSearching = true;
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
                          }
                        });
                      },
                    ),
                  ]),
              body: isNotSearching
                  ? buildCategory(
                      context) // we can put catogory here and add new stream for description search
                  : TabBarView(children: [
                      buildResult(searchInput, context),
                      buildSearchByDescription(searchInput, context),
                    ]),
            )));
  }

  Widget buildSearchByDescription(String searchInput, BuildContext context) {
    Stream<QuerySnapshot<Map<String, dynamic>>> snap = FirebaseFirestore
        .instance
        .collection('events')
        .where('approved', isEqualTo: true)
        .where('searchDescription', arrayContains: searchInput.toLowerCase())
        .snapshots();

    return searchInput.length == 0
        ? Scaffold()
        : StreamBuilder<Object>(
            stream: snap,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: Loading());
              }

              if (snapshot.data.size == 0 && searchInput.length != 0) {
                return Center(
                  child: Text(
                      "We're sorry. We were not able to find a match\nTry Another Saerch"),
                );
              }
              return ListView(
                children: snapshot.data.docs.map<Widget>((document) {
                  DocumentSnapshot uid = document;
                  return Padding(
                      padding: const EdgeInsets.all(10),
                      //  const EdgeInsets.only(right: 70),
                      child: Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side:
                                  BorderSide(width: 0.5, color: Colors.amber)),
                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          //color: Colors.orangeAccent,
                          child: ListTile(
                            title: Center(
                                child: Text(
                              document['name'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.amber[600],
                                  fontFamily: 'Comfortaa',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            )),
                            /*  subtitle: Text(
                                                  document['date'].toString(),
                                                  style: TextStyle(
                                                      color: Colors.amber[600],
                                                      fontFamily: 'Comfortaa',
                                                      fontSize: 14),
                                                ), */
                            // 00:000
                            trailing: Icon(
                              Icons.arrow_forward_ios_sharp,
                              color: Colors.purple[300],
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          eventDetailsForUesers(
                                            event: uid,
                                            // change to move to details and booked
                                          )));
                            },
                          )));
                }).toList(), //docmnt
              );
            });
  }

  Widget buildResult(String searchInput, context) {
    return searchInput.length == 0
        ? Scaffold()
        : StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('events')
                .where('approved', isEqualTo: true)
                .where('nameLowerCase',
                    isGreaterThanOrEqualTo: searchInput.toLowerCase())
                .where('nameLowerCase',
                    isLessThan: searchInput.toLowerCase() + 'z')
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: Loading());
              }
              if (snapshot.data.size == 0) {
                return Center(
                  child: Text(
                      "We're sorry. We were not able to find a match\nTry Another Saerch"),
                  heightFactor: 30,
                );
              }
              return ListView(
                children: snapshot.data.docs.map<Widget>((document) {
                  DocumentSnapshot uid = document;
                  return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          color: Colors.grey[200],
                          child: ListTile(
                            title: Center(
                                child: Text(
                              document['name'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.deepOrange,
                                  fontFamily: 'Comfortaa',
                                  fontSize: 16),
                            )),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          eventDetailsForUesers(
                                            event: uid,
                                          )));
                            },
                          )));
                }).toList(),
              );
            },
          );
  }

  Widget buildSearchByName(String searchInput, BuildContext context) {
    Stream<QuerySnapshot<Map<String, dynamic>>> snap = FirebaseFirestore
        .instance
        .collection('events')
        .where('approved', isEqualTo: true)
        .where('nameLowerCase',
            isGreaterThanOrEqualTo: searchInput.toLowerCase())
        .where('nameLowerCase', isLessThan: searchInput.toLowerCase() + 'z')
        .snapshots();

    return searchInput.length == 0
        ? Scaffold()
        : StreamBuilder<Object>(
            stream: snap,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: Loading());
              }
              if (snapshot.data.size == 0 && searchInput.length != 0) {
                return Center(
                  child: Text(
                      "We're sorry. We were not able to find a match\nTry Another Saerch"),
                  heightFactor: 30,
                );
              }
              return ListView(
                children: snapshot.data.docs.map<Widget>((document) {
                  DocumentSnapshot uid = document;
                  return Padding(
                      padding: const EdgeInsets.all(10),
                      //  const EdgeInsets.only(right: 70),
                      child: Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side:
                                  BorderSide(width: 0.5, color: Colors.amber)),
                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          //color: Colors.orangeAccent,
                          child: ListTile(
                            title: Center(
                                child: Text(
                              document['name'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.amber[600],
                                  fontFamily: 'Comfortaa',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            )),
                            /*  subtitle: Text(
                                                  document['date'].toString(),
                                                  style: TextStyle(
                                                      color: Colors.amber[600],
                                                      fontFamily: 'Comfortaa',
                                                      fontSize: 14),
                                                ), */
                            // 00:000
                            trailing: Icon(
                              Icons.arrow_forward_ios_sharp,
                              color: Colors.purple[300],
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          eventDetailsForUesers(
                                            event: uid,
                                            // change to move to details and booked
                                          )));
                            },
                          )));
                }).toList(), //docmnt
              );
            });
  }

  Widget buildCategory(context) {
// SizedBox(
//                 height: 10,
//               ),
    final category = [
      'Educational',
      'Sports',
      'Arts',
      'Academic',
      'Culture',
      'Video Games',
      'Activities',
      'Beauty',
      'Health',
      'Career',
      'Personal Growth',
      'Other'
    ];
// for(int i =0 ; i<category.length; i++ ){

// }
    return SingleChildScrollView(
        child: Column(
      children: [
        Card(
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            color: Colors.orange.shade100,
            child: ListTile(
              title: Center(
                  child: Text(
                "Educational",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.orange.shade500,
                    fontFamily: 'Comfortaa',
                    fontSize: 24),
              )),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        MyEventsByCategory(category: "Educational")));
              },
            )),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 80,
          child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              color: Colors.orange.shade100,
              child: ListTile(
                title: Center(
                    child: Text(
                  "Sports",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.orange.shade500,
                      fontFamily: 'Comfortaa',
                      fontSize: 24),
                )),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          MyEventsByCategory(category: "Sports")));
                },
              )),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 80,
          child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              color: Colors.orange.shade100,
              child: ListTile(
                title: Center(
                    child: Text(
                  "Arts",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.orange.shade500,
                      fontFamily: 'Comfortaa',
                      fontSize: 24),
                )),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          MyEventsByCategory(category: "Arts")));
                },
              )),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 80,
          child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              color: Colors.orange.shade100,
              child: ListTile(
                title: Center(
                    child: Text(
                  "Academic",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.orange.shade500,
                      fontFamily: 'Comfortaa',
                      fontSize: 24),
                )),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          MyEventsByCategory(category: "Academic")));
                },
              )),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 80,
          child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              color: Colors.orange.shade100,
              child: ListTile(
                title: Center(
                    child: Text(
                  "Culture",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.orange.shade500,
                      fontFamily: 'Comfortaa',
                      fontSize: 24),
                )),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          MyEventsByCategory(category: "Culture")));
                },
              )),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 80,
          child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              color: Colors.orange.shade100,
              child: ListTile(
                title: Center(
                    child: Text(
                  "Video Games",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.orange.shade500,
                      fontFamily: 'Comfortaa',
                      fontSize: 24),
                )),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          MyEventsByCategory(category: "Video Games")));
                },
              )),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 80,
          child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              color: Colors.orange.shade100,
              child: ListTile(
                title: Center(
                    child: Text(
                  "Activities",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.orange.shade500,
                      fontFamily: 'Comfortaa',
                      fontSize: 24),
                )),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          MyEventsByCategory(category: "Activities")));
                },
              )),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 80,
          child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              color: Colors.orange.shade100,
              child: ListTile(
                title: Center(
                    child: Text(
                  "Beauty",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.orange.shade500,
                      fontFamily: 'Comfortaa',
                      fontSize: 24),
                )),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          MyEventsByCategory(category: "Beauty")));
                },
              )),
        ),
        // SizedBox(
        //   height: 10,
        // ),
        // Container(
        //   height: 80,
        //   child: Card(
        //       elevation: 0,
        //       shape:
        //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        //       margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        //       color: Colors.orange.shade100,
        //       child: ListTile(
        //         title: Center(
        //             child: Text(
        //           "Health",
        //           textAlign: TextAlign.center,
        //           style: TextStyle(
        //               color: Colors.orange.shade500,
        //               fontFamily: 'Comfortaa',
        //               fontSize: 24),
        //         )),
        //         onTap: () {
        //           Navigator.of(context).push(MaterialPageRoute(
        //               builder: (context) =>
        //                   MyEventsByCategory(category: "Health")));
        //         },
        //       )),
        // ),
        // SizedBox(
        //   height: 10,
        // ),
        // Container(
        //   height: 80,
        //   child: Card(
        //       elevation: 0,
        //       shape:
        //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        //       margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        //       color: Colors.orange.shade100,
        //       child: ListTile(
        //         title: Center(
        //             child: Text(
        //           "Career",
        //           textAlign: TextAlign.center,
        //           style: TextStyle(
        //               color: Colors.orange.shade500,
        //               fontFamily: 'Comfortaa',
        //               fontSize: 24),
        //         )),
        //         onTap: () {
        //           Navigator.of(context).push(MaterialPageRoute(
        //               builder: (context) =>
        //                   MyEventsByCategory(category: "Career")));
        //         },
        //       )),
        // ),
        // SizedBox(
        //   height: 10,
        // ),
        // Container(
        //   height: 80,
        //   child: Card(
        //       elevation: 0,
        //       shape:
        //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        //       margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        //       color: Colors.orange.shade100,
        //       child: ListTile(
        //         title: Center(
        //             child: Text(
        //           "Personal Growth",
        //           textAlign: TextAlign.center,
        //           style: TextStyle(
        //               color: Colors.orange.shade500,
        //               fontFamily: 'Comfortaa',
        //               fontSize: 24),
        //         )),
        //         onTap: () {
        //           Navigator.of(context).push(MaterialPageRoute(
        //               builder: (context) =>
        //                   MyEventsByCategory(category: "Personal Growth")));
        //         },
        //       )),
        // ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 80,
          child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              color: Colors.orange.shade100,
              child: ListTile(
                title: Center(
                    child: Text(
                  "Other",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.orange.shade500,
                      fontFamily: 'Comfortaa',
                      fontSize: 24),
                )),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          MyEventsByCategory(category: "Other")));
                },
              )),
        )
      ],
    ));
  }
}

// class categoryWdget extends StatelessWidget {
//   const categoryWdget({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return
//   }
// }
