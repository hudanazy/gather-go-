//import 'package:firebase_app/screens/comment/coment_comment.dart';
//import 'package:firebase_app/screens/comment/comment_page.dart';
//import 'package:firebase_app/screens/comment/stream_comment_count.dart';
//import 'package:firebase_app/services/db.dart';
//import 'package:firebase_app/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gather_go/Models/UesrInfo.dart';
import 'package:gather_go/services/database.dart';
import 'package:provider/provider.dart';
import 'package:gather_go/Models/comment.dart';
import 'package:gather_go/services/database.dart';
import 'package:gather_go/Models/NewUser.dart';
import 'package:gather_go/shared/cons.dart';
import 'package:gather_go/screens/home/comments/stream_comment_count.dart';

class CommentComponent extends StatefulWidget {
  Comment? comment;
  CommentComponent({this.comment});

  @override
  _CommentComponentState createState() => _CommentComponentState();
}

class _CommentComponentState extends State<CommentComponent> {
  UesrInfo? userPost;
  @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   getUser();
  // }

  // getUser() async {
  //   final u = await DatabaseService().getUser(widget.comment.id_user);
  //   if (u != null) {
  //     userPost = u;
  //     setState(() {});
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(top: 10, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (userPost != null)
            Center(
              child: Stack(
                children: [
                  ClipOval(
                    child: Material(
                      color: Colors.transparent,
                      child: userPost?.imageUrl == ''
                          ? Image.asset(
                              'images/profile.png',
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            )
                          : Ink.image(
                              image: NetworkImage(userPost?.imageUrl as String),
                              fit: BoxFit.cover,
                              width: 160,
                              height: 160,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          Container(
            margin: EdgeInsets.only(left: 10),
            padding: EdgeInsets.only(top: 10, left: 10, right: 10),
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // if (userPost != null)
                //   Text(
                //     "${userPost.pseudo}",
                //     style: style.copyWith(
                //         fontSize: 18,
                //         fontWeight: FontWeight.bold,
                //         color: Colors.yellowAccent),
                //   ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 3),
                  color: Colors.black.withOpacity(.3),
                  height: 1,
                  width: width / 1.5,
                ),
                Container(
                  alignment: Alignment.centerRight,
                  width: width / 1.5,
                  child: Text(
                    "${widget.comment?.msg}",
                    style: style.copyWith(color: Colors.white, fontSize: 18),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        FontAwesomeIcons.solidThumbsUp,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () async {},
                    ),
                    Text("0",
                        style: TextStyle(fontSize: 17, color: Colors.white)),
                    IconButton(
                      icon: Icon(
                        FontAwesomeIcons.solidThumbsDown,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () async {},
                    ),
                    Text("0",
                        style: TextStyle(fontSize: 17, color: Colors.white)),
                    StreamProvider<int>.value(
                      initialData: 0,
                      value: DatabaseService()
                          .getCountCommentComment(widget.comment?.id as String),
                      child: StreamCommentComment(
                        comment: widget.comment,
                        user: userPost,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
