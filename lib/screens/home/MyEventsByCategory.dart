import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gather_go/Models/NewUser.dart';
import 'package:gather_go/screens/myAppBar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:gather_go/shared/loading.dart';
import 'package:provider/provider.dart';

import 'eventDetailsForUsers.dart';

// ignore: camel_case_types
class MyEventsByCategory extends StatefulWidget {
  final String? category;
  MyEventsByCategory({required this.category});
  @override
  _MyEventsByCategory createState() => _MyEventsByCategory(category);
}

// here i want to show all new event (not approved yet -> in DB approved = false)
// ignore: camel_case_types
class _MyEventsByCategory extends State<MyEventsByCategory> {
  final String? category;
  _MyEventsByCategory(this.category);
  @override
  Widget build(BuildContext context) {
    String _address = "";
    FutureBuilder<String?> namep;
    final user = Provider.of<NewUser?>(context);
    String uuuu = FirebaseAuth.instance.currentUser!.uid;
    Stream<QuerySnapshot<Map<String, dynamic>>> snap = FirebaseFirestore
        .instance
        .collection('events')
        .where('category', isEqualTo: category)
        .where('approved', isEqualTo: true)
        .snapshots();

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: SecondaryAppBar(
          title: "All $category Events",
        ),
        body: Container(
          alignment: Alignment.center,
          // height: 600,
          //  width: 340,
          child: //[
              StreamBuilder(
                  stream:
                      //StreamGroup.merge([
                      snap,
                  // stream2,
                  //  ]),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Loading(),
                      );
                    }
                    return ListView(
                      children: snapshot.data.docs.map<Widget>((document) {
                        DocumentSnapshot uid = document;
                        if (document['uid'] == user?.uid) {
                          return Padding(padding: EdgeInsets.all(0));
                        }

                        if (document["browseDate"]
                            .toDate()
                            .isBefore(DateTime.now())) {
                          return Padding(padding: EdgeInsets.all(0));
                        }

                        namep = FutureBuilder<String?>(
                            future: pos(document["lat"], document["long"]),
                            // initalData: 0,
                            builder:
                                (context, AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.hasData) {
                                return Text(snapshot.data.toString(),
                                    style: TextStyle(
                                        color: Colors.orange[300],
                                        fontWeight: FontWeight.w600,
                                        //fontSize: 16,
                                        fontFamily: "Comfortaa"));
                              } else {
                                return Text("Tap to see location",
                                    style: TextStyle(
                                        color: Colors.orange[300],
                                        fontWeight: FontWeight.w600,
                                        //fontSize: 16,
                                        fontFamily: "Comfortaa"));
                              }
                            });

                        return Padding(
                            padding: const EdgeInsets.all(8),
                            //  const EdgeInsets.only(right: 70),
                            child: GestureDetector(
                              child: Card(
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                elevation: 3.0,
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  color: Colors.white,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 0.0,
                                      ),
                                      AspectRatio(
                                          aspectRatio: 2.5,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                                topLeft:
                                                    const Radius.circular(20),
                                                topRight:
                                                    const Radius.circular(20)),
                                            child: document['imageUrl'] != ""
                                                ? Image.network(
                                                    document['imageUrl'],
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.asset(
                                                    'images/evv.jpg',
                                                    //   width: 200,
                                                    height: 200,
                                                    fit: BoxFit.cover,
                                                  ),
                                          )),
                                      Row(
                                        children: <Widget>[
                                          IconButton(
                                            icon: Icon(
                                              Icons.location_on_outlined,
                                              textDirection: TextDirection.ltr,
                                              color: Colors.orange[300],
                                              size: 25,
                                            ),
                                            //Location()

                                            onPressed: () {},
                                          ),
                                          namep,
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          SizedBox(
                                            width: 40.0,
                                            height: 40,
                                          ),
                                          Text(
                                            document['name'].substring(
                                                0,
                                                document['name'].length < 25
                                                    ? document['name'].length
                                                    : 25),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18,
                                                fontFamily: "Comfortaa"),
                                          ),
                                          Text(
                                            document['name'].length >= 25
                                                ? ".."
                                                : "",
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15,
                                                fontFamily: "Comfortaa"),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          SizedBox(
                                            width: 40.0,
                                          ),
                                          Text(
                                            document['description'].substring(
                                                0,
                                                document['description'].length <
                                                        25
                                                    ? document['description']
                                                        .length
                                                    : 25),
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15,
                                                fontFamily: "Comfortaa"),
                                          ),
                                          Text(
                                            document['description'].length >= 25
                                                ? ".."
                                                : "",
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15,
                                                fontFamily: "Comfortaa"),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 16.0,
                                      ),
                                    ],
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            eventDetailsForUesers(
                                              event: uid,
                                              // change to move to details and booked
                                            )));
                              },
                            ));
                      }).toList(), //docmnt
                      // )
                    );
                  }),
          //        ],
        ));
  }
}

Future<String?> pos(lat, long) async {
  List<Placemark> newPlace = await placemarkFromCoordinates(lat, long);

  Placemark placeMark = newPlace[0];
  String? name = placeMark.name;
  String? subLocality = placeMark.subLocality;
  String? locality = placeMark.locality;
  String? administrativeArea = placeMark.administrativeArea;
  String? postalCode = placeMark.postalCode;
  String? country = placeMark.country;
  String address =
      "${name}, ${subLocality}, ${locality}, ${administrativeArea} ${postalCode}, ${country}";

  String? location;
  String? area;
  int index;
  if (locality != "") {
    location = locality.toString();
  } else {
    // area = administrativeArea.toString();
    // index = area.indexOf(' ');
//    location = area.substring(0, index);
    location = administrativeArea.toString();
  }
  return location;
}
