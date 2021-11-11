import 'package:flutter/material.dart';
import 'package:gather_go/services/database.dart';
import 'package:provider/provider.dart';
import 'package:gather_go/Models/NewUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  //const NewMessage({Key? key}) : super(key: key);
  final DocumentSnapshot? event;
  NewMessage({required this.event});

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = "";
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<NewUser?>(context);
    return Container(
      margin: EdgeInsets.only(bottom: 3),
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
              child: TextField(
            decoration: InputDecoration(labelText: "Add a comment..."),
            onChanged: (value) {
              setState(() {
                _enteredMessage = value;
              });
            },
          )),
          IconButton(
            onPressed: () async {
              if (_enteredMessage.trim().isEmpty) {
                print("no message");
                return;
              } else {
                print(widget.event?.data().toString());
                await DatabaseService(uid: user?.uid).addCommentData(
                    _enteredMessage, user!.uid, widget.event?.id, 0, 0);
              }
            },
            icon: Icon(Icons.send),
            color: Colors.blueAccent,
          )
        ],
      ),
    );
  }
}
