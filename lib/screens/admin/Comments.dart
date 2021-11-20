import 'package:flutter/material.dart';
import 'package:gather_go/screens/myAppBar.dart';

class Comments extends StatefulWidget {
  const Comments({ Key? key }) : super(key: key);

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(title: 'Reported Comments',),
      body: Container(),
    );
  }
}