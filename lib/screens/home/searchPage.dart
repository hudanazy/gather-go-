import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gather_go/Models/NewUser.dart';
import 'package:gather_go/shared/loading.dart';
import 'package:provider/provider.dart';

class SearchList extends StatefulWidget {
  final String searchInput;
  SearchList({required this.searchInput});
  @override
  _SearchListState createState() => new _SearchListState();
}

class _SearchListState extends State<SearchList> {
  List searchresult = [];

  String searchInput = "h";
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<NewUser?>(context, listen: false);

    searchresult.clear();
    Stream<QuerySnapshot<Map<String, dynamic>>> stream = FirebaseFirestore
        .instance // do not forget casesensitivity , this sulotion does not support it
        .collection('events')
        // .orderBy("timePosted")
        .where('uid', isNotEqualTo: user?.uid)
        .where('approved', isEqualTo: true)
        .where('adminCheck', isEqualTo: true)
        .where('events',
            isGreaterThanOrEqualTo: searchInput,
            isLessThan: searchInput.substring(0, searchInput.length - 1) +
                String.fromCharCode(
                    searchInput.codeUnitAt(searchInput.length - 1) + 1))
        .snapshots();
// .where('description', isGreaterThanOrEqualTo: searchInput)
//                         .where('description', isLessThan: searchInput +'z')
//                         .snapshots();
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(children: [
          StreamBuilder(
              stream: stream,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Loading(),
                  );
                }
                return Text("shahad");
              })
        ]));
  }
}
