import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gather_go/screens/myAppBar.dart';
import 'package:gather_go/shared/loading.dart';

class Comments extends StatefulWidget {
  const Comments({ Key? key }) : super(key: key);

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot<Map<String, dynamic>>> stream = 
    FirebaseFirestore.instance.collection('comments')
    .orderBy('reportNumber', descending: true)
    .where('reportNumber', isGreaterThan: 0 )
    .snapshots();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: MyAppBar(title: 'Reported Comments',),
      body: Container(
        alignment: Alignment.center,
        child: StreamBuilder(
          stream: stream,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (!snapshot.hasData){
              return Center(
                  child: Loading(),
                );
            }
            if (snapshot.data.size == 0)
              return Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text(
                  "No reported comments.",
                  textAlign: TextAlign.center,
                ),
              );
            return ListView(
              children: 
              snapshot.data.docs.map<Widget>( (document){
                DocumentSnapshot doc = document;
                  final now = DateTime.now();
                  final past = document['timePosted'].toDate();

                  final differenceDays =
                      now.difference(past).inDays;
                  final differenceHours =
                      now.difference(past).inHours;
                  final differenceMinutes =
                      now.difference(past).inMinutes;
                  final differenceSeconds =
                      now.difference(past).inSeconds;
                  final differenceMS =
                      now.difference(past).inMilliseconds;
                  String ago = "";

                  if (differenceDays == 0) {
                    if (differenceHours == 0) {
                      if (differenceMinutes == 0) {
                        if (differenceSeconds == 0) {
                          if (differenceMS == 0) {
                            ago = "now";
                          } else {
                            ago = differenceMS.toString() + "ms";
                          }
                        } else {
                          ago =
                              differenceSeconds.toString() + "s";
                        }
                      } else {
                        ago = differenceMinutes.toString() + "m";
                      }
                    } else {
                      ago = differenceHours.toString() + "h";
                    }
                  } else {
                    var months;
                    if (differenceDays > 30) {
                      months = differenceDays / 30;
                      ago = ((months).floor()).toString() + "mo";
                      var year;
                      if (months >= 12) {
                        year = months / 12;
                        ago = year.floor().toString() + "y";
                      }
                    } else {
                      ago = differenceDays.toString() + "d";
                    }
                  }
        return Padding(
          padding: const EdgeInsets.all(8),
          //  const EdgeInsets.only(right: 70),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
                child: 
                Column(children: [
                Row(children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Center(
                      child: 
                      Stack(
                        children: [
                          ClipOval(
                            child: Material(
                              color: Colors.transparent,
                              child:
                                document['imageUrl'] == ""
                                  ? Image.asset(
                                      'images/profile.png',
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    )
                                  : Ink.image(
                                    image: NetworkImage(
                                        document[
                                            'imageUrl']),
                                    fit: BoxFit.cover,
                                    width: 60,
                                      height: 60,
                                    ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(
                        top: 10, left: 20, right: 10),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.3),
                        borderRadius:
                            BorderRadius.circular(10)),
                    child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.end,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: 
                            Flexible(child:  Text(
                              document['name'],
                              style: TextStyle(
                                  color:
                                      Colors.orange[700]),
                            ),)
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: 
                            Flexible(
                            child: Text(document['text'])),
                          ),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.end,
                            children: [
                              Text(ago), //maybe we don't need it ??
                                SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width: 30,
                                  child: 
                                Icon(Icons.report,
                                color: Colors.red,
                                  size: 20,
                                )),
                                Flexible(child: 
                                Text(
                                  document['reportNumber'].toString())),
                                Text(' '),
                              ],
                            ),
                          ]),
                          ),
                        ),
                      ]),
                                Container(
                                  padding: EdgeInsets.only(top: 5),
                                  //width: MediaQuery.of(context).size.width ,// /2,
                                child: Row( children:[
                                ElevatedButton(
                                  child: Text("Delete Comment",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),),
                                  onPressed: (){},
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.only(top: 15, bottom: 15),
                                   primary: Colors.orange[400],
                                   shape: RoundedRectangleBorder(
                                     side: BorderSide(
                                       width: 0.5,
                                       color: Colors.white),
                                    borderRadius:
                                        BorderRadius.only(topLeft: Radius.circular(15),
                                        bottomLeft:  Radius.circular(10),) ,
                                    ),
                                    ),),
                                    ElevatedButton(
                                  child: Text("Ignore",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),),
                                  onPressed: (){},
                                  style: ElevatedButton.styleFrom(
                                    //minimumSize: Size.infinite,
                                    padding: EdgeInsets.only(top: 15, bottom: 15),
                                   primary: Colors.orange[400],
                                   shape: RoundedRectangleBorder(
                                     side: BorderSide(
                                       width: 0.5,
                                       color: Colors.white),
                                    borderRadius:
                                        BorderRadius.only(topRight: Radius.circular(15), 
                                        bottomRight:  Radius.circular(10),) ,
                                    ),
                                    ),)]))
                             // ],
                            //),
                ]),
                    ),
                );
              }

              ).toList() ,
            );
          }),
      ),
    );
  }
}