import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gather_go/Models/UesrInfo.dart';
import 'package:provider/provider.dart';

class uesrList extends StatefulWidget {
  const uesrList({Key? key}) : super(key: key);

  @override
  _uesrListState createState() => _uesrListState();
}

class _uesrListState extends State<uesrList> {
  @override
  Widget build(BuildContext context) {
    final uesrs = Provider.of<List<UesrInfo>>(context);
    uesrs.forEach((UesrInfo) {
      print(UesrInfo.uesrname);
      print(UesrInfo.email);
      // print(UesrInfo.password);
    });

    return Container();
  }
}
