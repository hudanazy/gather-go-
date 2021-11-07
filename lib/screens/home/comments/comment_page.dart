//import 'package:firebase_app/model/comment.dart';
import 'package:gather_go/Models/EventInfo.dart';
import 'package:gather_go/Models/NewUser.dart';
import 'package:gather_go/screens/home/eventDetailsForUsers.dart';
//import 'package:firebase_app/screens/comment/comment_component.dart';
import 'package:gather_go/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gather_go/Models/comment.dart';
import 'package:gather_go/screens/home/comments/comment_component.dart';

class CommentWidget extends StatelessWidget {
  EventInfo? event;
  CommentWidget({this.event});
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //final user = Provider.of<NewUser?>(context);
    final comments = Provider.of<List<Comment?>>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("List of comments"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              // child: ListView(),
              child: comments == null
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                    )
                  : comments.length == 0
                      ? Center(
                          child: Text("No letters"),
                        )
                      : ListView.builder(
                          itemCount: comments.length,
                          itemBuilder: (ctx, i) {
                            final comment = comments[i];
                            return CommentComponent(comment: comment);
                          },
                        )),
          Container(
            padding: EdgeInsets.all(5),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: commentController,
                    minLines: 1,
                    maxLines: 5,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.green,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () async {
                      bool commentOk = await DatabaseService().add_comment(
                          Comment(
                              id_comment_pub: event?.uid,
                              id_user: NewUser.currentUser?.uid,
                              msg: commentController.text));
                      if (commentOk) commentController.clear();
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
