import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gather_go/Models/NewUser.dart';
import 'package:gather_go/screens/home/MyEventsDetails.dart';
import 'package:gather_go/screens/myAppBar.dart';

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
  //bool searchInputBool=false ; // to avoid display result when the input is empty
  Color backColor = Colors.amber;
  Widget appBarTitle = new Text('\nSearch',
      style: TextStyle(
          color: Colors.black,
          fontFamily: 'Comfortaa',
          fontSize: 24,
          fontWeight: FontWeight.bold));
  //Icon actionIcon = new Icon(Icons.search, color: Colors.black, size: 40);
  bool isSearchByCategory = true;
  Color appBarColor = Colors.transparent;
  TabBar tabs = TabBar(
    tabs: [],
  );

  int tabNum = 0;
  // String searchInput = "h";
  @override // mey move search bar to the appBar
  Widget build(BuildContext context) {
    final user = Provider.of<NewUser?>(context, listen: false);
    String? UId = user?.uid;

    //var _controller = TextEditingController();
    return //MaterialApp(
        //home: 
        DefaultTabController(
            length: tabNum,
            child: Scaffold(
            appBar: MyAppBar(title: 'Search for events',),
            body: Scaffold(
              backgroundColor: Colors.white10,
              resizeToAvoidBottomInset: false,
              appBar: new AppBar(
                  backgroundColor: appBarColor,
                  elevation: 0,
                  //centerTitle: true,
                  bottom: tabs,
                  title: TextField(
                    onTap: (){
                      setState(() {
                        isSearchByCategory=false;
                        appBarColor= Colors.white;
                        tabNum = 2;
                            isNotSearching = false;
                            this.tabs = new TabBar(
                              indicatorColor: Colors.orange[300],
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
                            //this.actionIcon = 
                      });
                    },
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 15),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        color: Colors.orange.shade300,
                                        width: 2),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
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
                            ),
                  actions: isSearchByCategory? null: <Widget>[ 
                    new IconButton(
                      padding: const EdgeInsets.only(right: 10, top: 22),
                      //iconSize: 40,
                      icon: new Icon(Icons.cancel,
                                color: Colors.black, size: 27),
                      onPressed: () {
                        setState(() {
                          // if (this.actionIcon.icon == Icons.search) {
                          //   //this.appBarTitle = 
                          // } else {
                            FocusScope.of(context).unfocus();
                            appBarColor= Colors.transparent;
                            isSearchByCategory=true;
                            searchInput = "";
                            tabNum = 0;
                            isNotSearching = true;
                            this.tabs = new TabBar(
                              indicatorColor: Colors.purple[600],
                              labelColor: Colors.black,
                              labelStyle: TextStyle(
                                fontFamily: 'Comfortaa',
                                fontSize: 22,
                              ),
                              tabs: [],
                            );
                            // this.actionIcon = new Icon(Icons.search,
                            //     color: Colors.black, size: 40);
                            // this.appBarTitle = new Text('\nSearch ',
                            //     style: TextStyle(
                            //         color: Colors.black,
                            //         fontFamily: 'Comfortaa',
                            //         fontSize: 24,
                            //         fontWeight: FontWeight.bold));
                          }
                        //}
                        );
                      },
                    ),
                  ]),
              body: Container(child: isNotSearching
                  ? buildCategory(
                      context) // we can put catogory here and add new stream for description search
                  : TabBarView(children: [
                      buildResult(searchInput, context, UId),
                      buildSearchByDescription(searchInput, context, UId),
                    ]),
                     )
            ))//)
            );
  }

  Widget buildSearchByDescription(
      String searchInput, BuildContext context, String? UId) {
    String uuuu = FirebaseAuth.instance.currentUser!.uid;
    searchInput = searchInput.trimLeft();
    Stream<QuerySnapshot<Map<String, dynamic>>> snap = FirebaseFirestore
        .instance
        .collection('events')
        .where('approved', isEqualTo: true)
        .where('searchDescription', arrayContains: searchInput.toLowerCase())
        .snapshots();

    bool isOnlySpace = false;
    int j = 0; // counter of spaces number in searchInput
    for (int i = 0; i < searchInput.length; i++) {
      if (searchInput.substring(i, i + 1) == " ") j++;
    }
    if (j == searchInput.length) isOnlySpace = true;

    return isOnlySpace
        ? Scaffold()
        : StreamBuilder<Object>(
            stream: snap,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: Loading());
              }

              if (snapshot.data.size == 0 && searchInput.length != 0) {
                return Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Text(
                    "Sorry. We were not able to find a match\nTry Another Saerch",
                    textAlign: TextAlign.center,
                  ),
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
                                color: Colors.black,
                                fontFamily: 'Comfortaa',
                                fontSize: 16,
                              ),
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
                              color: Colors.orange[300],
                            ),
                            onTap: () {
                              if (document['uid'] == uuuu) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyEventsDetails(
                                              event: uid,
                                            )));
                              } else
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

  Widget buildResult(
    String searchInput,
    context,
    String? UId,
  ) {
    String uuuu = FirebaseAuth.instance.currentUser!.uid;
    bool isOnlySpace = false;
    int j = 0; // counter of spaces number in searchInput
    for (int i = 0; i < searchInput.length; i++) {
      if (searchInput.substring(i, i + 1) == " ") j++;
    }
    if (j == searchInput.length) isOnlySpace = true;
    searchInput = searchInput.trimLeft();
    return isOnlySpace
        ? Scaffold()
        : StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('events')
                .where('approved', isEqualTo: true)
                //.where('uid', isNotEqualTo: uuuu)
                .where('nameLowerCase',
                    arrayContains: searchInput.toLowerCase())
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: Loading());
              }
              if (snapshot.data.size == 0) {
                return Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Text(
                    "Sorry. We were not able to find a match\nTry Another Saerch",
                    textAlign: TextAlign.center,
                  ),
                  //heightFactor: 30,
                );
              }

              return isOnlySpace
                  ? Scaffold()
                  : // to avoid search when the input space
                  ListView(
                      children: snapshot.data.docs.map<Widget>((document) {
                        DocumentSnapshot uid = document;
                        return Padding(
                            padding: const EdgeInsets.all(10),
                            child: Card(
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                        width: 0.5, color: Colors.amber)),
                                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                //color: Colors.grey[200],
                                child: ListTile(
                                  title: Center(
                                      child: Text(
                                    document['name'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Comfortaa',
                                      fontSize: 16,
                                    ),
                                  )),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.orange[300],
                                  ),
                                  onTap: () {
                                    if (document['uid'] == uuuu) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MyEventsDetails(
                                                    event: uid,
                                                  )));
                                    } else
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
      'Outdoor Activities',
      'Beauty',
      'Health',
      'Career',
      'Personal Growth',
      'Other'
    ];

    return GridView(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      children: [
        GestureDetector(
          child: Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            //color: Colors.orange.shade100,

            child: Stack(children: [
              ClipRRect(
                borderRadius: BorderRadius.all(const Radius.circular(20)),
                child: Image.asset(
                  'images/educational.jpg',
                  //   width: 200,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                //left: 10,
                child: Container(
                  width: 280,
                  height: 50,
                  color: Colors.white,
                  child: Row(children: [
                    SizedBox(width: 20),
                    Text(
                      "Educational",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Comfortaa',
                        fontSize: 20,
                        // fontWeight: FontWeight.w600
                      ),
                    ),
                  ]),
                ),
              )
            ]),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    MyEventsByCategory(category: "Educational")));
          },
        ),
        GestureDetector(
          child: Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            //color: Colors.orange.shade100,

            child: Stack(children: [
              ClipRRect(
                borderRadius: BorderRadius.all(const Radius.circular(20)),
                child: Image.asset(
                  'images/sports.jpg',
                  //   width: 200,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                //left: 10,
                child: Container(
                  width: 280,
                  height: 50,
                  color: Colors.white,
                  child: Row(children: [
                    SizedBox(width: 20),
                    Text(
                      "Sports",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Comfortaa',
                        fontSize: 20,
                        // fontWeight: FontWeight.w700
                      ),
                    ),
                  ]),
                ),
              )
            ]),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MyEventsByCategory(category: "Sports")));
          },
        ),
        GestureDetector(
          child: Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            //color: Colors.orange.shade100,

            child: Stack(children: [
              ClipRRect(
                borderRadius: BorderRadius.all(const Radius.circular(20)),
                child: Image.asset(
                  'images/arts.jpg',
                  //   width: 200,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                //left: 10,
                child: Container(
                  width: 280,
                  height: 50,
                  color: Colors.white,
                  child: Row(children: [
                    SizedBox(width: 20),
                    Text(
                      "Arts",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Comfortaa',
                        fontSize: 20,
                        // fontWeight: FontWeight.w700
                      ),
                    ),
                  ]),
                ),
              )
            ]),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MyEventsByCategory(category: "Arts")));
          },
        ),
        GestureDetector(
          child: Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            //color: Colors.orange.shade100,

            child: Stack(children: [
              ClipRRect(
                borderRadius: BorderRadius.all(const Radius.circular(20)),
                child: Image.asset(
                  'images/academic.webp',
                  //   width: 200,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                //left: 10,
                child: Container(
                  width: 280,
                  height: 50,
                  color: Colors.white,
                  child: Row(children: [
                    SizedBox(width: 20),
                    Text(
                      "Academic",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Comfortaa',
                        fontSize: 20,
                        // fontWeight: FontWeight.w700
                      ),
                    ),
                  ]),
                ),
              )
            ]),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    MyEventsByCategory(category: "Academic")));
          },
        ),
        GestureDetector(
          child: Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            //color: Colors.orange.shade100,

            child: Stack(children: [
              ClipRRect(
                borderRadius: BorderRadius.all(const Radius.circular(20)),
                child: Image.asset(
                  'images/culture.webp',
                  //   width: 200,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                //left: 10,
                child: Container(
                  width: 280,
                  height: 50,
                  color: Colors.white,
                  child: Row(children: [
                    SizedBox(width: 20),
                    Text(
                      "Culture",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Comfortaa',
                        fontSize: 20,
                        // fontWeight: FontWeight.w700
                      ),
                    ),
                  ]),
                ),
              )
            ]),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MyEventsByCategory(category: "Culture")));
          },
        ),
        GestureDetector(
          child: Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            //color: Colors.orange.shade100,

            child: Stack(children: [
              ClipRRect(
                borderRadius: BorderRadius.all(const Radius.circular(20)),
                child: Image.asset(
                  'images/vid.webp',
                  //   width: 200,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                //left: 10,
                child: Container(
                  width: 280,
                  height: 50,
                  color: Colors.white,
                  child: Row(children: [
                    SizedBox(width: 20),
                    Text(
                      "Video Games",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Comfortaa',
                        fontSize: 20,
                        // fontWeight: FontWeight.w700
                      ),
                    ),
                  ]),
                ),
              )
            ]),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    MyEventsByCategory(category: "Video Games")));
          },
        ),
        GestureDetector(
          child: Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            //color: Colors.orange.shade100,

            child: Stack(children: [
              ClipRRect(
                borderRadius: BorderRadius.all(const Radius.circular(20)),
                child: Image.asset(
                  'images/outdoor.jpg',
                  //   width: 200,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                //left: 10,
                child: Container(
                  width: 280,
                  height: 50,
                  color: Colors.white,
                  child: Row(children: [
                    SizedBox(width: 20),
                    Text(
                      "Outdoor Activities",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Comfortaa',
                        fontSize: 15,
                        // fontWeight: FontWeight.w700
                      ),
                    ),
                  ]),
                ),
              )
            ]),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    MyEventsByCategory(category: "Outdoor Activities")));
          },
        ),
        GestureDetector(
          child: Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            //color: Colors.orange.shade100,

            child: Stack(children: [
              ClipRRect(
                borderRadius: BorderRadius.all(const Radius.circular(20)),
                child: Image.asset(
                  'images/beauty.webp',
                  //   width: 200,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                //left: 10,
                child: Container(
                  width: 280,
                  height: 50,
                  color: Colors.white,
                  child: Row(children: [
                    SizedBox(width: 50),
                    Text(
                      "Beauty",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Comfortaa',
                        fontSize: 20,
                        // fontWeight: FontWeight.w700
                      ),
                    ),
                  ]),
                ),
              )
            ]),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MyEventsByCategory(category: "Beauty")));
          },
        ),
        GestureDetector(
          child: Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            //color: Colors.orange.shade100,

            child: Stack(children: [
              ClipRRect(
                borderRadius: BorderRadius.all(const Radius.circular(20)),
                child: Image.asset(
                  'images/health.jpg',
                  //   width: 200,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                //left: 10,
                child: Container(
                  width: 280,
                  height: 50,
                  color: Colors.white,
                  child: Row(children: [
                    SizedBox(width: 50),
                    Text(
                      "Health",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Comfortaa',
                        fontSize: 20,
                        // fontWeight: FontWeight.w700
                      ),
                    ),
                  ]),
                ),
              )
            ]),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MyEventsByCategory(category: "Health")));
          },
        ),
        GestureDetector(
          child: Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            //color: Colors.orange.shade100,

            child: Stack(children: [
              ClipRRect(
                borderRadius: BorderRadius.all(const Radius.circular(20)),
                child: Image.asset(
                  'images/career.jpg',
                  //   width: 200,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                //left: 10,
                child: Container(
                  width: 280,
                  height: 50,
                  color: Colors.white,
                  child: Row(children: [
                    SizedBox(width: 50),
                    Text(
                      "Career",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Comfortaa',
                        fontSize: 20,
                        // fontWeight: FontWeight.w700
                      ),
                    ),
                  ]),
                ),
              )
            ]),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MyEventsByCategory(category: "Career")));
          },
        ),
        GestureDetector(
          child: Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            //color: Colors.orange.shade100,

            child: Stack(children: [
              ClipRRect(
                borderRadius: BorderRadius.all(const Radius.circular(20)),
                child: Image.asset(
                  'images/growth.jpg',
                  //   width: 200,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                //left: 10,
                child: Container(
                  width: 280,
                  height: 50,
                  color: Colors.white,
                  child: Row(children: [
                    SizedBox(width: 20),
                    Text(
                      "Personal Growth",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Comfortaa',
                        fontSize: 15,
                        // fontWeight: FontWeight.w700
                      ),
                    ),
                  ]),
                ),
              )
            ]),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    MyEventsByCategory(category: "Personal Growth")));
          },
        ),
        GestureDetector(
          child: Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            //color: Colors.orange.shade100,

            child: Stack(children: [
              ClipRRect(
                borderRadius: BorderRadius.all(const Radius.circular(20)),
                child: Image.asset(
                  'images/other.jpg',
                  //   width: 200,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                //left: 10,
                child: Container(
                  width: 280,
                  height: 50,
                  color: Colors.white,
                  child: Row(children: [
                    SizedBox(width: 50),
                    Text(
                      "Other",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Comfortaa',
                        fontSize: 20,
                        // fontWeight: FontWeight.w700
                      ),
                    ),
                  ]),
                ),
              )
            ]),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MyEventsByCategory(category: "Other")));
          },
        ),
      ],
    );
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
