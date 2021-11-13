import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gather_go/Models/NewUser.dart';
import 'package:gather_go/search/searchTab.dart';
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
  // String searchInput = "h";
  @override // mey move search bar to the appBar
  Widget build(BuildContext context) {
    final user = Provider.of<NewUser?>(context, listen: false);
    String? UId = user?.uid;
    // Stream<QuerySnapshot<Map<String, dynamic>>> stream = FirebaseFirestore
    //     .instance // do not forget casesensitivity , this sulotion does not support it
    //     .collection('events')
    //     // .orderBy("timePosted")
    //     .where('uid', isNotEqualTo: UId)
    //     .where('approved', isEqualTo: true)
    //     .where('adminCheck', isEqualTo: true)
    //     // .where('events',
    //     //     isGreaterThanOrEqualTo: val,
    //     //     isLessThan: val.substring(0, val.length - 1) +
    //     //         String.fromCharCode(
    //     //             val.codeUnitAt(val.length - 1) + 1))
    //     .snapshots();
    var _controller = TextEditingController();
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 110,
          backgroundColor: Colors.white,
          title: TextField(
            //controller: _controller,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 15),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orangeAccent, width: 2),
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
            onChanged: (val) {
              if (val.length == 0) {
                isNotSearching = true;
              }
              setState(() {
                isNotSearching = false;
                searchInput = val;
                if (val.length == 0) {
                  isNotSearching = true;
                }
              });
            },
            //  onTap: () {},
          ),
        ),
        body: Container(
          child: buildResult(searchInput, context),
        ),
      ),
    );
  }

  Widget buildResult(String searchInput, context) {
    return isNotSearching
        ? buildCategory(
            context) // we can put catogory here and add new stream for description search
        : StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('events')
                .where('approved', isEqualTo: true)
                // .where(
                //   'name',
                //   isGreaterThanOrEqualTo: searchInput,
                // )
                .where('nameLowerCase', // lower case didnt work
                    isGreaterThanOrEqualTo:
                        searchInput.toLowerCase()) //toLowerCase()
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
              return Column(
                children: [
                  Container(
                      // need to change the size
                      height: 440,
                      width: 500,
                      child: ListView(
                        children: snapshot.data.docs.map<Widget>((document) {
                          DocumentSnapshot uid = document;
                          return Padding(
                              padding: const EdgeInsets.all(8),
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  margin:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                      )),
                ],
              );
            },
          );
  }
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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

// class categoryWdget extends StatelessWidget {
//   const categoryWdget({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return
//   }
// }
