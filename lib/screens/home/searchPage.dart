import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gather_go/Models/NewUser.dart';
import 'package:gather_go/screens/home/search.dart';
import 'package:gather_go/shared/loading.dart';
import 'package:provider/provider.dart';

import 'eventDetailsForUsers.dart';

class SearchList extends StatefulWidget {
  // final String searchInput;
  // SearchList({required this.searchInput});
  @override
  _SearchListState createState() => new _SearchListState();
}

class _SearchListState extends State<SearchList> {
  List searchresult = [];
  List tempSearchresult = [];
  bool isNotSearching = true;
  String searchInput = "";
  // String searchInput = "h";
  @override // mey move search bar to the appBar
  Widget build(BuildContext context) {
    final user = Provider.of<NewUser?>(context, listen: false);
    String? UId = user?.uid;
    Stream<QuerySnapshot<Map<String, dynamic>>> stream = FirebaseFirestore
        .instance // do not forget casesensitivity , this sulotion does not support it
        .collection('events')
        // .orderBy("timePosted")
        .where('uid', isNotEqualTo: UId)
        .where('approved', isEqualTo: true)
        .where('adminCheck', isEqualTo: true)
        // .where('events',
        //     isGreaterThanOrEqualTo: val,
        //     isLessThan: val.substring(0, val.length - 1) +
        //         String.fromCharCode(
        //             val.codeUnitAt(val.length - 1) + 1))
        .snapshots();
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
                  onSubmitted: (val) {
                    //initialSearch(val);
                  },
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
                  }),
            ),
            body: Container(
              child: buildResult(searchInput),
            )));
//   return Scaffold(
//         backgroundColor: Colors.white,
//         body: ListView(children: [
//           StreamBuilder(
//               stream: stream,
//               builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//                 if (!snapshot.hasData) {
//                   return Center(
//                     child: Loading(),
//                   );
//                 }
//                 return Text("shahad");
//               })
//         ]));
  }

//  List searchresult = [];
//   List tempSearchresult = [];
  void initialSearch(String val) {
    //Future<QuerySnapshot<Map<String, dynamic>>> snap = SearchService().searchByName(val);
    Stream<QuerySnapshot<Map<String, dynamic>>> snap =
        FirebaseFirestore.instance
            // do not forget casesensitivity , this sulotion does not support it
            .collection('events')
            .where('approved', isEqualTo: true)
            .where('name', isGreaterThanOrEqualTo: val) //,
            // isLessThan: searchField.substring(0, searchField.length - 1) +
            //     String.fromCharCode(
            //         searchField.codeUnitAt(searchField.length - 1) + 1))
            .snapshots();
  }

  Widget buildResult(String searchInput) {
    return isNotSearching
        ? Text("") // we can put catogory here
        : StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('events')
                .where('approved', isEqualTo: true)
                .where(
                  'name',
                  isGreaterThanOrEqualTo: searchInput,
                )
                // .where('fieldName',
                //     isGreaterThanOrEqualTo: searchInput.toLowerCase())
                // .where('fieldName', isLessThan: searchInput + 'z')
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: Loading());
              }
              if (snapshot.data.size == 0) {
                return Center(
                  child: Text("No result found..."),
                  heightFactor: 30,
                );
              }
              return Container(
                  // need to change the size
                  height: 640,
                  width: 500,
                  child: ListView(
                    children: snapshot.data.docs.map<Widget>((document) {
                      DocumentSnapshot uid = document;
                      return Padding(
                          padding: const EdgeInsets.all(8),
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
                  ));
            },
          );
  }
}
