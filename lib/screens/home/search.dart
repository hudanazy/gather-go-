import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gather_go/screens/admin/eventDetails.dart';
import 'package:gather_go/shared/loading.dart';

// ignore: camel_case_types
class searchResult extends StatefulWidget {
  @override
  _searchResult createState() => _searchResult();
}

// here i want to show all new event (not approved yet -> in DB approved = false)
// ignore: camel_case_types
class _searchResult extends State<searchResult> {
  Stream<QuerySnapshot<Map<String, dynamic>>> snap = FirebaseFirestore.instance
      .collection('events')
      .where('approved', isEqualTo: true)
      .where('name', isGreaterThanOrEqualTo: "h") //,
      // isLessThan: searchField.substring(0, searchField.length - 1) +
      //     String.fromCharCode(
      //         searchField.codeUnitAt(searchField.length - 1) + 1))
      .snapshots();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            StreamBuilder(
              stream: snap,
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
                                            builder: (context) => eventDetails(
                                                  event: uid,
                                                )));
                                  },
                                )));
                      }).toList(),
                    ));
              },
            ),
          ],
        ));
  }
}
