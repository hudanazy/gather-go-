import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class uesrList extends StatefulWidget {
  const uesrList({Key? key}) : super(key: key);

  @override
  _uesrListState createState() => _uesrListState();
}

class _uesrListState extends State<uesrList> {
  @override
  Widget build(BuildContext context) {
    final uesrs = Provider.of<QuerySnapshot>(context);
    //print(uesrs);
    for (var doc in uesrs.docs) print(doc.data);

    return Container();
  }
}
