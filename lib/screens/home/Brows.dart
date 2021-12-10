import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gather_go/Models/NewUser.dart';
import 'package:gather_go/screens/home/eventDetailsForUsers.dart';
import 'package:gather_go/screens/myAppBar.dart';
import 'package:provider/provider.dart';
import 'package:gather_go/shared/loading.dart';
import 'package:async/async.dart' show StreamGroup;
import 'package:geocoding/geocoding.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

const Color KAppColor = Color(0xFFFFB300);

// List<Map> categories = [
//   {
//     "name": 'SPORT',
//     'icon': Icons.sports_basketball,
//   },
//   {
//     "name": 'ART',
//     'icon': Icons.bubble_chart,
//   },
//   /* {
//     "name": 'MUSIC',
//     'icon': Icons.music_note,
//   }, */

//   {
//     "name": 'Games',
//     'icon': Icons.games_outlined,
//   },
//   {
//     "name": 'Other',
//     'icon': Icons.more,
//   },
// ];

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

/* 
void initState() {
    super.initState();
    getUserLocation();
    _titleController = new TextEditingController(text: widget.note.title);
    _descriptionController = new TextEditingController(text: widget.note.description);
    _locationController = new TextEditingController(text: widget.note.location);
  } */
/* 
final now = DateTime.now();
final expirationDate = DateTime(2021, 1, 10);
final bool isExpired = expirationDate.isBefore(now); //exaple
 */
/* 
DateTime _now = DateTime.now();
DateTime _start = DateTime(_now.year, _now.month, _now.day, 0, 0);
DateTime _end = DateTime(_now.year, _now.month, _now.day, 21, 12, 59);
var currDt = DateTime.now().toString();
var timen = DateTime.now().hour; */

class _HomeScreenState extends State<HomeScreen> {
  final AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    'This channel is used for important notifications.',
    importance: Importance.max,
  );
  var flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  _HomeScreenState() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
  // final user = Provider.of<NewUser?>(context, listen: false);
  // Stream<QuerySnapshot<Map<String, dynamic>>> snap = FirebaseFirestore.instance
  //     .collection('events')
  //     // .orderBy("timePosted")
  //     .where('approved', isEqualTo: true)
  //     .where('adminCheck', isEqualTo: true)
  //.where('uid',isNotEqualTo: )
  //.where('date', isGreaterThanOrEqualTo: DateTime.now().toString())
  //.where('date', isGreaterThanOrEqualTo: _start) //not return
  // .where(DateTime.now().toString(), isGreaterThanOrEqualTo: 'date')//not return data
  // .orderBy('date')
  //.orderBy('lat')

/* 
      .collection("events")
      .orderBy("time") */

//location
/* .collection("events")
.orderBy("lat", "asc") */
/* .collection("events")
.orderBy("long", "asc") */
//---------------------------------------------
//date

/*  print(currDt.year); // 4
print(currDt.weekday); // 4
print(currDt.month); // 4
print(currDt.day); // 2
print(currDt.hour); // 15
print(currDt.minute); // 21
print(currDt.second); // 49 */

  //-------------------------
  //.orderBy(TimeOfDay.now())
  //  .where('date', isGreaterThanOrEqualTo: new DateTime.now())
  // .where('date', isGreaterThanOrEqualTo: now) //exption
  // .where('time', isGreaterThanOrEqualTo: now)//exption
  // .where('date').limit(7)//number doc

  // .where('date',isExpired:false)
  // .where('date',  isGreaterThanOrEqualTo: new DateTime.now().toString()) //exption

  //new time
  // .where('date', isGreaterThanOrEqualTo: new DateTime.now().toString())//exption

  /* .where('time',
          isGreaterThanOrEqualTo: new DateTime.now().toString()) */ //exption

  /* .where('timePosted',
          isGreaterThanOrEqualTo: new DateTime.fromMillisecondsSinceEpoch(7)) */ //exp

  /*  .where('timePosted',
          isGreaterThanOrEqualTo: new DateTime.fromMicrosecondsSinceEpoch(1)) */ //exp
  // .elementAt(now)

  // .where('location', isEqualTo: 'Latlang')

  //   .where("location", isGreaterThan: lesserGeoPoint)not
  //    .where("location", isLessThan: greaterGeoPoint);not
  //Geocoder
  //.where("location", isEqualTo: LatLng )
  //.where("location", isEqualTo: LatLng(24.774265, 46.738586)) //chick
  // .where("location", isGreaterThanOrEqualTo: LatLng)
  // .snapshots();
  //is approved
  // int _selectedCategory = 0;
/* 
  static var now = DateTime.now();

  static var timeToCheck;

  static get string => null; */

  // List<Widget> buildCategoriesWidgets() {
  //   List<Widget> categoriesWidgets = [];
  //   for (Map category in categories) {
  //     categoriesWidgets.add(GestureDetector(
  //       child: Container(
  //         color: _selectedCategory == categories.indexOf(category)
  //             ? KAppColor
  //             : Colors.transparent,
  //         padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
  //         child: Row(
  //           children: [
  //             Icon(category['icon'], color: Colors.purple[300]),
  //             SizedBox(width: 5),
  //             Text(category['name'],
  //                 style: TextStyle(color: Colors.purple[300])),
  //           ],
  //         ),
  //       ),
  //       onTap: () {
  //         setState(() {
  //           /* scrollDirection:
  //           Axis.horizontal; */
  //           _selectedCategory = categories.indexOf(category);
  //         });
  //       },
  //     ));
  //   }
  //   return categoriesWidgets;
  // }

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.instance.getToken();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      print(message.data.toString());
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              //importance: Importance.max,
              //priority: Priority.max,
              icon: '@drawable/ic_flutternotification',
              styleInformation: BigTextStyleInformation(''),
            ),
          ),
        );
      }
      return;
    });
    final user = Provider.of<NewUser?>(context, listen: false);
    String _address = "";
    FutureBuilder<String?> namep;
    // DateTime dt = DateTime.parse();
    //final user = Provider.of<NewUser?>(context, listen: false);
    // Stream<QuerySnapshot<Map<String, dynamic>>> stream1 = FirebaseFirestore
    //     .instance
    //     .collection('events')
    //     .where('uid', isNotEqualTo: user!.uid)
    //     .orderBy("uid")
    //     .where('approved', isEqualTo: true)
    //     .where('adminCheck', isEqualTo: true)
    //     .orderBy("timePosted", descending: true)
    //     .snapshots();

    Stream<QuerySnapshot<Map<String, dynamic>>> stream1 =
        FirebaseFirestore.instance
            .collection('events')
            // .where('uid', isNotEqualTo: user!.uid)
            .where('approved', isEqualTo: true)
            .where('adminCheck', isEqualTo: true)
            // .orderBy("uid", descending: true)
            .orderBy("timePosted", descending: true)
            .snapshots();

    return Scaffold(
        backgroundColor: Colors.white10,
        appBar: MyAppBar(title: 'Upcoming Events'),
        body: Container(
          alignment: Alignment.center,
          // height: 600,
          //  width: 340,
          child: //[
              StreamBuilder(
                  stream:
                      //StreamGroup.merge([
                      stream1,
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
                                      Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            children: <Widget>[
                                              if (document['RatingNumber'] > 0)
                                                RatingBar.builder(
                                                  itemSize: 15,
                                                  initialRating:
                                                      document['rating'],
                                                  glow: true,
                                                  ignoreGestures: true,
                                                  minRating: 1,
                                                  allowHalfRating: true,
                                                  itemCount: 5,
                                                  itemPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 4.0),
                                                  itemBuilder: (context, _) =>
                                                      Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                  ),
                                                  onRatingUpdate: (value) {},
                                                ),
                                              /*  if (theRatingNumber > 0)
                            InkWell(
                              child: Text(
                                '($Count)',
                                style: TextStyle(fontSize: 10),
                              ),
                            ) */
                                            ],
                                          )),
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
