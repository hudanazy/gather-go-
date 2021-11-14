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
  dynamic _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

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
            minLines: 1,
            maxLines: 5,
            controller: _controller,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                hintText: "Add a comment..",
                focusColor: Colors.grey,
                hoverColor: Colors.grey,
                // labelText: "Add a comment...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                )),
            onChanged: (value) {
              setState(() {
                _enteredMessage = value;
              });
            },
          )),
          IconButton(
            onPressed: (_enteredMessage.trim().isEmpty)
                ? null
                : () async {
                    print(widget.event?.data().toString());
                    await DatabaseService(uid: user?.uid).addCommentData(
                        _enteredMessage,
                        user!.uid,
                        widget.event!.id,
                        0,
                        0,
                        DateTime.now().toString());
                    _controller.clear();
                    setState(() {
                      _enteredMessage = "";
                    });
                  },
            icon: Icon(Icons.send),
            color: Colors.blueAccent,
          )
        ],
      ),
    );
  }
}
