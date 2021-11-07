import 'package:flutter/material.dart';
import 'package:gather_go/Models/EventInfo.dart';
import 'package:gather_go/Models/UesrInfo.dart';
import 'package:gather_go/Models/comment.dart';
import 'package:gather_go/services/database.dart';
import 'package:provider/provider.dart';
import 'package:gather_go/screens/home/comments/comment_component.dart';
import 'package:gather_go/screens/home/comments/comment_page.dart';
import 'package:gather_go/screens/home/comments/comet_comment.dart';

class StreamComment extends StatelessWidget {
  EventInfo? vehicule;
  StreamComment({this.vehicule});
  @override
  Widget build(BuildContext context) {
    final comment_lenght = Provider.of<int>(context);
    String count = "";
    if (comment_lenght != null) {
      count = comment_lenght > 1
          ? "$comment_lenght commentaires"
          : "$comment_lenght commentaire";
    }
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.message,
            color: Colors.grey,
            size: 20,
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => StreamProvider<List<Comment>>.value(
                      initialData: [],
                      value: DatabaseService().gecomment(vehicule!.uid),
                      child: CommentWidget(
                        event: vehicule,
                      ),
                    )));
          },
        ),
        Text(count)
      ],
    );
  }
}

class StreamCommentComment extends StatelessWidget {
  Comment? comment;
  UesrInfo? user;
  StreamCommentComment({this.comment, this.user});
  @override
  Widget build(BuildContext context) {
    final comment_lenght = Provider.of<int>(context);
    int count = 0;
    if (comment_lenght != null) {
      count = comment_lenght;
    }
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.message,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => StreamProvider<List<Comment>>.value(
                      initialData: [],
                      value: DatabaseService()
                          .gecommentComment(comment?.id as String),
                      child: CommentCommentWidget(
                          comment: comment, user: this.user),
                    )));
          },
        ),
        Text("$count", style: TextStyle(fontSize: 17, color: Colors.white))
      ],
    );
  }
}
