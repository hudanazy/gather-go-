import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:gather_go/Models/NewUser.dart';
import 'package:gather_go/screens/home/profile_form.dart';
import 'package:gather_go/screens/myAppBar.dart';

import 'package:gather_go/shared/loading.dart';
import 'package:provider/provider.dart';

import 'eventDetailsForUsers.dart';
import 'package:async/async.dart' show StreamGroup;
import 'package:geocoding/geocoding.dart';

// ignore: camel_case_types
class BookedEvents extends StatefulWidget {
  @override
  _BookedEvents createState() => _BookedEvents();
}

// here i want to show all new event (not approved yet -> in DB approved = false)
// ignore: camel_case_types
class _BookedEvents extends State<BookedEvents> {
  @override
  Widget build(BuildContext context) {
    //final user = Provider.of<NewUser?>(context);
    final user = Provider.of<NewUser?>(context, listen: false);
    String _address = "";
    FutureBuilder<String?> namep;
    Stream<QuerySnapshot<Map<String, dynamic>>> snap = FirebaseFirestore
        .instance
        .collection('events')
        .where('attendeesList', arrayContainsAny: [user!.uid])
        .orderBy('timePosted', descending: true)
        .snapshots();
//'events.uid', arrayContainsAny:

    return Scaffold(
        appBar: SecondaryAppBar(title: "All Booked Events"),
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
                    return //Container(
                        // height: 600,
                        // width: 320,
                        //  child:
                        ListView(
                      // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      // crossAxisCount: 2),

                      children: snapshot.data.docs.map<Widget>((document) {
                        DocumentSnapshot uid = document;
                        // if (document['uid'] == user?.uid) {
                        //   return Padding(padding: EdgeInsets.all(0));
                        // }

                        // if (document["browseDate"]
                        //     .toDate()
                        //     .isBefore(DateTime.now())) {
                        //   return Padding(padding: EdgeInsets.all(0));
                        // }

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

                        //  namep = FutureProvider<String?>(
                        // initialData: "",
                        // create: (context) =>
                        //     pos(document["lat"], document["long"]),
                        // // initalData: 0,
                        // builder: (context, snapshot) {
                        //   return Text(
                        //     snapshot.toString(),
                        //   );
                        // });

                        //namep = pos(document["lat"], document["long"]);

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
                              )

                              // Card(
                              //     elevation: 6,
                              //     shape: RoundedRectangleBorder(
                              //         borderRadius:
                              //             BorderRadius.circular(10),
                              //         side: BorderSide(
                              //             width: 0.5,
                              //             color: Colors.orange.shade400)),
                              //     margin: const EdgeInsets.fromLTRB(
                              //         10, 0, 10, 0),
                              //     //color: Colors.orangeAccent,
                              //     child: ListTile(
                              //       title: Center(
                              //           child: Text(
                              //         document['name'],
                              //         textAlign: TextAlign.center,
                              //         style: TextStyle(
                              //             color: Colors.black,
                              //             fontFamily: 'Comfortaa',
                              //             fontSize: 16,
                              //             ),
                              //       )),
                              //       /*  subtitle: Text(
                              //         document['date'].toString(),
                              //         style: TextStyle(
                              //             color: Colors.amber[600],
                              //             fontFamily: 'Comfortaa',
                              //             fontSize: 14),
                              //       ), */
                              //       // 00:000
                              //       trailing: Icon(
                              //         Icons.arrow_forward_ios_sharp,
                              //         color: Colors.purple[300],
                              //       ),
                              // onTap: () {
                              //   Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) =>
                              //               eventDetailsForUesers(
                              //                 event: uid,
                              //                 // change to move to details and booked
                              //               )));
                              // },
                              //     )));
                              ,
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
// Container(
//     //height: 200,
//     // width: 400,
//    // padding: EdgeInsets.all(0),
//     color: Colors.white,
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
// Row(
//   children: [
/* Icon(
                          Icons.location_on_outlined,
                          color: Colors.white,
                        ), */
/* Text(
                          'Current Location will removed',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            // decoration: TextDecoration.underline,
                          ),
                        ) */

//             // Text(
//             //   'Gather Go',
//             //   textAlign: TextAlign.center,
//             //   style:
//             //       TextStyle(color: Colors.amber[600], fontSize: 55

//             //           // decoration: TextDecoration.underline,
//             //           ),
//             // )
//   ],
// ),
//         // TextField(
//         //   decoration: InputDecoration(
//         //     contentPadding: EdgeInsets.symmetric(vertical: 15),
//         //     focusedBorder: OutlineInputBorder(
//         //       borderSide:
//         //           BorderSide(color: Colors.purple, width: 0.5),
//         //     ),
//         //     enabledBorder: OutlineInputBorder(
//         //       borderSide:
//         //           BorderSide(color: Colors.amberAccent, width: 0.5),
//         //     ),
//         //     hintText: "Search",
//         //     hintStyle: TextStyle(color: Colors.purple[300]),
//         //     prefixIcon:
//         //         Icon(Icons.search, color: Colors.purple[300]),
//         //     suffixIcon:
//         //         Icon(Icons.filter_list, color: Colors.purple[300]),
//         //   ),
//         //   onChanged: (val) {
//         //     // SearchList(searchInput: val);
//         //   },
//         // ),
//         // Container(
//         //     height: 30,
//         //     child: Row(
//         //       //children: buildCategoriesWidgets(),
//         //     ))
//   ],
// )),
//SizedBox(height: 15),
// Text(
//   'Here you can browse upcoming events',
//   textAlign: TextAlign.center,
//   style: TextStyle(
//       color: Colors.purple[300],
//       fontSize: 17,
//       fontWeight: FontWeight.bold),
// ),
//SizedBox(height: 20),
// Padding(
//     padding: const EdgeInsets.all(30),
//     // padding: const EdgeInsets.only(left: 30),
//     child: Column(
//   children: [
//       Row(
//      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//      children: [
//SizedBox(height: 30),
//       ],
//     )
//    ],
// ))

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
