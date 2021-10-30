import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gather_go/screens/admin/eventDetails.dart';
import 'package:gather_go/screens/home/eventDetailsForUsers.dart';
import 'package:gather_go/screens/home/event_list.dart';
import 'package:gather_go/screens/home/profile_form.dart';
import 'package:gather_go/screens/home/createEvent.dart';
import 'package:gather_go/services/auth.dart';
import 'package:gather_go/screens/home/user_list.dart';
import 'package:gather_go/shared/gradient_app_bar.dart';
import 'package:gather_go/shared/loading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const Color KAppColor = Color(0xFFFFB300);

List<Map> categories = [
  {
    "name": 'SPORT',
    'icon': Icons.sports_basketball,
  },
  {
    "name": 'ART',
    'icon': Icons.bubble_chart,
  },
  /* {
    "name": 'MUSIC',
    'icon': Icons.music_note,
  }, */

  {
    "name": 'Games',
    'icon': Icons.games_outlined,
  },
  {
    "name": 'Other',
    'icon': Icons.more,
  },
];

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

DateTime _now = DateTime.now();
DateTime _start = DateTime(_now.year, _now.month, _now.day, 0, 0);
DateTime _end = DateTime(_now.year, _now.month, _now.day, 21, 12, 59);
var currDt = DateTime.now().toString();
var timen = DateTime.now().hour;

class _HomeScreenState extends State<HomeScreen> {
  Stream<QuerySnapshot<Map<String, dynamic>>> snap = FirebaseFirestore.instance
      .collection('events')
      // .orderBy("timePosted")
      .where('approved', isEqualTo: true)
      .where('adminCheck', isEqualTo: true)
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
      .snapshots();
  //is approved
  int _selectedCategory = 0;
/* 
  static var now = DateTime.now();

  static var timeToCheck;

  static get string => null; */

  List<Widget> buildCategoriesWidgets() {
    List<Widget> categoriesWidgets = [];
    for (Map category in categories) {
      categoriesWidgets.add(GestureDetector(
        child: Container(
          color: _selectedCategory == categories.indexOf(category)
              ? KAppColor
              : Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Row(
            children: [
              Icon(category['icon'], color: Colors.purple[300]),
              SizedBox(width: 5),
              Text(category['name'],
                  style: TextStyle(color: Colors.purple[300])),
            ],
          ),
        ),
        onTap: () {
          setState(() {
            /* scrollDirection:
            Axis.horizontal; */
            _selectedCategory = categories.indexOf(category);
          });
        },
      ));
    }
    return categoriesWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            Container(
                height: 200,
                padding: EdgeInsets.all(20),
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
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

                        Text(
                          'Gather Go',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: Colors.amber[600], fontSize: 50

                                  // decoration: TextDecoration.underline,
                                  ),
                        )
                      ],
                    ),
                    TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.purple, width: 0.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.amberAccent, width: 0.5),
                        ),
                        hintText: "Search",
                        hintStyle: TextStyle(color: Colors.purple[300]),
                        prefixIcon:
                            Icon(Icons.search, color: Colors.purple[300]),
                        suffixIcon:
                            Icon(Icons.filter_list, color: Colors.purple[300]),
                      ),
                      onChanged: (val) {},
                    ),
                    Container(
                        height: 30,
                        child: Row(
                          children: buildCategoriesWidgets(),
                        ))
                  ],
                )),
            SizedBox(height: 15),
            Text(
              'Upcoming Events',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.purple[300],
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Padding(
                padding: const EdgeInsets.all(30),
                // padding: const EdgeInsets.only(left: 30),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(height: 350),
                        StreamBuilder(
                            stream: snap,
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: Loading(),
                                );
                              }

                              return Container(
                                  height: 350,
                                  width: 280,
                                  child: ListView(
                                    children: snapshot.data.docs
                                        .map<Widget>((document) {
                                      DocumentSnapshot uid = document;
                                      return Padding(
                                          padding: const EdgeInsets.all(8),
                                          //  const EdgeInsets.only(right: 70),
                                          child: Card(
                                              elevation: 6,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  side: BorderSide(
                                                      width: 3,
                                                      color: Colors.amber)),
                                              margin: const EdgeInsets.fromLTRB(
                                                  5, 0, 5, 0),
                                              //color: Colors.orangeAccent,
                                              child: ListTile(
                                                title: Center(
                                                    child: Text(
                                                  document['name'],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.amber[600],
                                                      fontFamily: 'Comfortaa',
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                                /*  subtitle: Text(
                                                  document['date'].toString(),
                                                  style: TextStyle(
                                                      color: Colors.amber[600],
                                                      fontFamily: 'Comfortaa',
                                                      fontSize: 14),
                                                ), */
                                                // 00:000
                                                trailing: Icon(
                                                  Icons.arrow_forward_ios_sharp,
                                                  color: Colors.purple[300],
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
                                              )));
                                    }).toList(), //docmnt
                                  ));
                            }),
                      ],
                    )
                  ],
                ))
          ],
        )); //scaffold
  }
}
