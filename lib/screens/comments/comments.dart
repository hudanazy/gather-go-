import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gather_go/services/database.dart';

class Comments extends StatelessWidget {
  //const Comments({Key? key}) : super(key: key);
  final Stream _commentStream =
      FirebaseFirestore.instance.collection('comments').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _commentStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          // final chatDocs = chatSnapshot.data?.docs;
          return ListView(
            children: snapshot.data?.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return new Text(data['text']);
              //  ListTile(
              //   title: new Text(data['full_name']),
              //   subtitle: new Text(data['company']),
              // );
            }).toList(),
          );
        });
  }
}
