import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gather_go/Models/NewUser.dart';
import 'package:gather_go/screens/home/MyEventsDetails.dart';

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
  Widget appBarTitle = new Text('\nSearch for Events',
      style: TextStyle(
          color: Colors.black, fontFamily: 'Comfortaa', fontSize: 24, fontWeight: FontWeight.bold));
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

    //var _controller = TextEditingController();
    return MaterialApp(
        home: DefaultTabController(
            length: tabNum,
            child: Scaffold(
              backgroundColor: Colors.white,
              resizeToAvoidBottomInset: false, 
              appBar: new AppBar(
                  backgroundColor: Colors.orange[400],
                  //centerTitle: true,
                  bottom: tabs,
                  title: appBarTitle,
                  actions: <Widget>[
                    new IconButton(
                      padding: const EdgeInsets.only( right: 10, top: 22),
                      //iconSize: 40,
                      icon: actionIcon,
                      onPressed: () {
                        setState(() {
                          if (this.actionIcon.icon == Icons.search) {
                            tabNum = 2;
                            isNotSearching = false;
                            this.tabs = new TabBar(
                              indicatorColor: Colors.purple[600],
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
                                        color: Colors.purple.shade600, width: 2),
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
                              indicatorColor: Colors.purple[600],
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
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold));
                          }
                        });
                      },
                    ),
                  ]),
              body: isNotSearching
                  ? buildCategory(
                      context) // we can put catogory here and add new stream for description search
                  : TabBarView(children: [
                      buildResult(searchInput, context, UId),
                      buildSearchByDescription(searchInput, context, UId),
                    ]),
            )));
  }

  Widget buildSearchByDescription(
      String searchInput, BuildContext context, String? UId) {
        String uuuu = FirebaseAuth.instance.currentUser!.uid;
        searchInput=searchInput.trimLeft();
    Stream<QuerySnapshot<Map<String, dynamic>>> snap = FirebaseFirestore
        .instance
        .collection('events')
        .where('approved', isEqualTo: true)
        .where('searchDescription', arrayContains: searchInput.toLowerCase())
        .snapshots();

bool isOnlySpace = false;
    int j=0; // counter of spaces number in searchInput 
    for (int i=0 ; i< searchInput.length ; i++){
      if(searchInput.substring(i,i+1)==" ")
      j++;

    }
    if(j==searchInput.length)
    isOnlySpace=true;


    return isOnlySpace? Scaffold(): StreamBuilder<Object>(
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
                      textAlign: TextAlign.center,),
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
                              color: Colors.purple[300],
                            ),
                            onTap: () {
                                                            if (document['uid']==uuuu)
              {                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MyEventsDetails(
                                            event: uid,
                                          )));}
                                          else
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

  Widget buildResult(String searchInput, context, String? UId , ) {
    String uuuu = FirebaseAuth.instance.currentUser!.uid;
    bool isOnlySpace = false;
    int j=0; // counter of spaces number in searchInput 
    for (int i=0 ; i< searchInput.length ; i++){
      if(searchInput.substring(i,i+1)==" ")
      j++;

    }
    if(j==searchInput.length)
    isOnlySpace=true;
searchInput=searchInput.trimLeft();
    return isOnlySpace? Scaffold():
         StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('events')
                .where('approved', isEqualTo: true)
                //.where('uid', isNotEqualTo: uuuu)
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
                return Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Text(
                      "Sorry. We were not able to find a match\nTry Another Saerch",
                      textAlign: TextAlign.center,),
                  //heightFactor: 30,
                );
              }
           
              return  isOnlySpace? Scaffold(): // to avoid search when the input space 
              ListView(
                children: snapshot.data.docs.map<Widget>((document) {
                  DocumentSnapshot uid = document;
                  return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Card(
                        elevation: 6,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side:
                                  BorderSide(width: 0.5, color: Colors.amber)),
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
                              color: Colors.purple[300],
                            ),
                            onTap: () {
                              if (document['uid']==uuuu)
              {                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MyEventsDetails(
                                            event: uid,
                                          )));}
                              else
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

    return  StreamBuilder<Object>(
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
                                  color: Colors.amber,
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

    return SingleChildScrollView(
        child: Column(
      children: [
        SizedBox(
          height: 10,
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
                  "Educational",
                  textAlign: TextAlign.center,
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
        SizedBox(
          height: 10,
        ),
        Container(
          height: 80,
          child: Card(
              elevation: 0,
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              color: Colors.orange.shade100,
              child: ListTile(
                title: Center(
                    child: Text(
                  "Health",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.orange.shade500,
                      fontFamily: 'Comfortaa',
                      fontSize: 24),
                )),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          MyEventsByCategory(category: "Health")));
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
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              color: Colors.orange.shade100,
              child: ListTile(
                title: Center(
                    child: Text(
                  "Career",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.orange.shade500,
                      fontFamily: 'Comfortaa',
                      fontSize: 24),
                )),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          MyEventsByCategory(category: "Career")));
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
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              color: Colors.orange.shade100,
              child: ListTile(
                title: Center(
                    child: Text(
                  "Personal Growth",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.orange.shade500,
                      fontFamily: 'Comfortaa',
                      fontSize: 24),
                )),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          MyEventsByCategory(category: "Personal Growth")));
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
