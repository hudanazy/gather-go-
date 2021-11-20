//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gather_go/Models/EventInfo.dart';
import 'package:gather_go/Models/NewUser.dart';
import 'package:gather_go/screens/home/MyEvents.dart';
import 'package:gather_go/services/database.dart';
import 'package:gather_go/shared/contants.dart';
import 'package:gather_go/shared/dialogs.dart';
import 'package:gather_go/shared/dialogs.dart';
import 'package:gather_go/shared/loading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:timezone/data/latest.dart' as tz;

//-----------------------

// import 'package:gather_go/screens/home/event_list.dart';
// import 'package:gather_go/screens/home/profile_form.dart';
// import 'package:get/get.dart';
//import 'package:syncfusion_flutter_datepicker/datepicker.dart';
//import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
//import 'package:gather_go/services/database.dart';
//import 'package:provider/provider.dart';
//import 'package:gather_go/Models/NewUser.dart';
//import 'package:gather_go/Models/EventInfo.dart';
//import 'package:gather_go/shared/contants.dart';
//import 'package:gather_go/shared/gradient_app_bar.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:gather_go/shared/dialogs.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:gather_go/screens/home/home.dart';
//import 'package:gather_go/screens/home/nav.dart';
//import 'package:location/location.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:gather_go/shared/num_button.dart';
import '../NotifactionManager.dart';
import 'MyEventsDetails.dart';
import 'nav.dart';
//import 'package:timezone/timezone.dart' as tz;
//import 'package:timezone/data/latest.dart' as tz;

//----------------------

class EidtEventForm extends StatefulWidget {
  final DocumentSnapshot? event;
  EidtEventForm({required this.event});
  // const EidtEventForm({Key? key}) : super(key: key);

  @override
  _eventEditFormState createState() => _eventEditFormState();
}

// ignore: camel_case_types
class _eventEditFormState extends State<EidtEventForm> {
  final List<String> category = [
    'Educational',
    'Sports',
    'Arts',
    'Academic',
    'Culture',
    'Video Games',
    'Activities',
    'Beauty',
    'Health',
    'Career',
    'Personal Growth',
    'Other'
  ];
  String? item = 'Other';

  final _formKey = GlobalKey<FormState>();

  //DateTime _dateTime = DateTime.now();
  TextEditingController eventName = TextEditingController(); // 1
  TextEditingController eventDescription = TextEditingController();
  DateRangePickerController eventDate = DateRangePickerController();

  //int _currentStep = 0;
  DateTime? dateo;
  TextEditingController? name;
  TextEditingController? description;

  String? Description;
  TimeOfDay? ttime;
  GeoPoint? location;
  DateRangePickerController Datee = DateRangePickerController();
  String? timeAgo;
  int _currentValue = 5;
  bool approved = false;
  LatLng _initialcameraposition = LatLng(24.708481, 46.752108);
  late GoogleMapController _controller;

  List<Marker> myMarker = [];
  LatLng saveLatLng = LatLng(24.708481, 46.752108);
  String? StringLatLng;

  double saveLat = 0;
  double saveLong = 0;
  @override
  void initState() {
    super.initState();
    // tz.initializeTimeZones();
    eventName = TextEditingController.fromValue(
      TextEditingValue(text: widget.event?.get('name')),
    );

    eventDescription = TextEditingController.fromValue(
      TextEditingValue(text: widget.event?.get('description')),
    );
  }

  @override
  void dispose() {
    eventName.dispose();
    super.dispose();
  }

  String? currentNameEvent = "";
  String? currentcatogary = "";
  String? currentDescrption = "";
  int? currattend = 0;
  String? currdate = "";
  String? currtime = "";
  double? currentlat = 0.0;
  double? currentlong = 0.0;
  EventInfo? eventData;

  //final user = Provider.of<NewUser?>(context, listen: false);
  //DateTime date;
  @override
  Widget build(BuildContext context) {
    bool adminCheck = widget.event?.get('adminCheck');
    bool approved = widget.event?.get('approved'); //111111111
    int attendeeNum = widget.event?.get('attendees');
    String userID = widget.event?.get('uid');

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: new Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(
                  context, MaterialPageRoute(builder: (context) => MyEvents()));
            },
          ),
          toolbarHeight: 100,
          backgroundColor: Colors.white,
          title: Text(
            "Edit your Event",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.orange[600],
                fontFamily: 'Comfortaa',
                fontSize: 24),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 50,
                        ),
                        /* Text(
                          "Edit your event",
                          style: TextStyle(
                              color: Colors.orange[600],
                              letterSpacing: 2,
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Comfortaa"),
                        ), */

                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(top: 20, left: 20),
                          child: Text(
                            "Event Name",
                            style: TextStyle(
                                color: Colors.orange[600],
                                letterSpacing: 2,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Comfortaa"),
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: 320,
                          child: TextFormField(
                            // controller: eventName,
                            maxLines: 1,
                            initialValue: widget.event?.get('name'),
                            //     widget.event?.get('name') + '   ', //wigit
                            decoration: textInputDecoration.copyWith(
                              hintText: "Event name..",
                              hintStyle: TextStyle(
                                  color: Colors.orange[600],
                                  fontFamily: "Comfortaa"),
                            ),

                            style: TextStyle(
                              color: Colors.orange[600],
                              fontFamily: 'Comfortaa',
                            ),
                            validator: (val) =>
                                val!.isEmpty ? 'Please enter a name' : null,
                            onChanged: (val) {
                              setState(() => currentNameEvent = val);
                            }, //name event
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(top: 20, left: 20),
                          child: Text(
                            "Event Category",
                            style: TextStyle(
                                color: Colors.orange[600],
                                letterSpacing: 2,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Comfortaa"),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: 320,
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          child: DropdownButtonFormField(
                              value: widget.event?.get('category'),
                              decoration: textInputDecoration,
                              items: category.map((category) {
                                return DropdownMenuItem(
                                  value: category,
                                  child: Text(category),
                                );
                              }).toList(),
                              onChanged: (val) => setState(
                                  () => currentcatogary = val as String),
                              style: TextStyle(
                                color: Colors.orange[600],
                                fontFamily: 'Comfortaa',
                              )),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(top: 20, left: 20),
                          child: Text(
                            "Event Description",
                            style: TextStyle(
                                color: Colors.orange[600],
                                letterSpacing: 2,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Comfortaa"),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: 320,
                          child: TextFormField(
                            maxLines: 5,
                            initialValue: widget.event?.get('description'),
                            decoration: textInputDecoration.copyWith(
                                hintText: "Tell us more about your event...",
                                hintStyle: TextStyle(
                                    color: Colors.orange[600],
                                    fontFamily: "Comfortaa")),
                            style: TextStyle(
                              color: Colors.orange[600],
                              fontFamily: 'Comfortaa',
                            ),
                            validator: (val) => val!.isEmpty
                                ? 'Please enter a descrption about event '
                                : null,
                            onChanged: (val) {
                              setState(() => currentDescrption = val);
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(top: 20, left: 50),
                          child: Text(
                            "How many attendees?",
                            style: TextStyle(
                                color: Colors.orange[600],
                                letterSpacing: 2,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Comfortaa"),
                          ),
                        ),

                        SizedBox(height: 20),
                        NumberPicker(
                          value: _currentValue,
                          minValue: 1,
                          maxValue: 500,
                          axis: Axis.horizontal,
                          onChanged: (value) =>
                              setState(() => _currentValue = value),
                        ),

                        SizedBox(height: 20),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Select new date ",
                                style: TextStyle(
                                    color: Colors.orange[600],
                                    letterSpacing: 2,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Comfortaa"),
                              ),
                              //Old
                              WidgetSpan(
                                child: IconButton(
                                  // label: Text(
                                  //   "Set event date",
                                  //   style: TextStyle(
                                  //     color: Colors.deepPurple,
                                  //     fontSize: 20,
                                  //     fontWeight: FontWeight.w500,
                                  //   ),
                                  // ),
                                  icon: Icon(
                                    Icons.calendar_today_rounded,
                                    color: Colors.orange[600],
                                    size: 50,
                                  ),
                                  // style: ElevatedButton.styleFrom(
                                  //   minimumSize: Size.fromHeight(40),
                                  //   primary: Colors.white,
                                  // ),
                                  onPressed: () => pickDate(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //-------------------------------------------time
                        SizedBox(height: 20),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Select new time ",
                                style: TextStyle(
                                    color: Colors.orange[600],
                                    letterSpacing: 2,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Comfortaa"),
                              ),
                              WidgetSpan(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.access_time,
                                    textDirection: TextDirection.ltr,
                                    color: Colors.orange[600],
                                    size: 50,
                                  ),
                                  // style: ElevatedButton.styleFrom(
                                  //   minimumSize: Size.fromHeight(40),
                                  //   primary: Colors.white,
                                  // ),
                                  onPressed: () => pickTime(context),
                                ),
                              ),
                            ],
                          ),
                        ),
//-----------------------------------------------------location
                        SizedBox(height: 40),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(top: 20, left: 50),
                          child: Text(
                            "Select new location",
                            style: TextStyle(
                                color: Colors.orange[600],
                                letterSpacing: 2,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Comfortaa"),
                          ),
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          height: 400,
                          width: 350,
                          child: GoogleMap(
                            initialCameraPosition:
                                CameraPosition(target: _initialcameraposition),
                            mapType: MapType.normal,
                            onMapCreated: _onMapCreated,
                            rotateGesturesEnabled: true,
                            scrollGesturesEnabled: true,
                            zoomControlsEnabled: true,
                            zoomGesturesEnabled: true,
                            liteModeEnabled: false,
                            tiltGesturesEnabled: true,
                            myLocationEnabled: true,
                            markers: Set.from(myMarker),
                            onTap: _handleTap,
                          ),
                        ),
                        // ---------------------- end location
                        SizedBox(height: 40),
                        SizedBox(
                          height: 50,
                          width: 190,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.orange[400]),
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.fromLTRB(35, 15, 35, 15))),
                            child: Text(
                              'Save Changes',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "Comfortaa"),
                            ),
                            onPressed: () async {
                              // print("hi im here 1 $Name");

                              ///print
                              if (_formKey.currentState!.validate()) {
                                if (currentNameEvent == "") {
                                  currentNameEvent = widget.event?.get('name');
                                }
                                if (currentDescrption == "") {
                                  currentDescrption =
                                      widget.event?.get('description');
                                }

                                if (currentcatogary == "") {
                                  currentcatogary =
                                      widget.event?.get('category');
                                }
                                if (attendeeNum == 0) {
                                  attendeeNum = widget.event?.get('attendees');
                                }

                                if (currdate == "") {
                                  currdate = widget.event?.get('date');
                                }

                                if (currtime == "") {
                                  currtime = widget.event?.get('time');
                                }

                                if (currentlat == 0 || currentlong == 0) {
                                  currentlat = widget.event?.get('lat');
                                  currentlong = widget.event?.get('long');
                                }
                                var result = await showEditEventDialog(context);
                                if (result == true) {
                                  try {
                                    FirebaseFirestore.instance
                                        .collection("events")
                                        .doc(widget.event?.id)
                                        .update({
                                      "name": currentNameEvent,
                                      "description": currentDescrption,
                                      "category": currentcatogary,
                                      "attendees": _currentValue,
                                      "date": currdate,
                                      "time": currtime,
                                      "lat": currentlat,
                                      "long": currentlong,
                                      "adminCheck": false,
                                      "approved": false,
                                    });

                                    // date

                                    Navigator.pop(context);
                                    Fluttertoast.showToast(
                                      msg: widget.event?.get('name') +
                                          " Event update successfully",
                                      toastLength: Toast.LENGTH_LONG,
                                    );
                                  } catch (e) {
                                    // fail msg
                                    Fluttertoast.showToast(
                                      msg: "somthing went wrong ",
                                      toastLength: Toast.LENGTH_SHORT,
                                    );
                                  }
                                } //if
                              } //--her
                            },
                          ),
                        ),
                        SizedBox(height: 40),
                      ],
                    ))),
          ],
        )));
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    // _location.onLocationChanged.listen((l) {
    //   _controller.animateCamera(
    //     CameraUpdate.newCameraPosition(
    //       CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 15),
    //     ),
    //   );
    // });
  }

  void _handleTap(LatLng tappedPoint) {
    setState(() {
      myMarker = [];
      myMarker.add(Marker(
          markerId: MarkerId(tappedPoint.toString()),
          position: tappedPoint,
          draggable: true,
          onDragEnd: (dragEndPosition) {
            print(dragEndPosition);
          }));
      currentlat = tappedPoint.latitude;
      currentlong = tappedPoint.longitude;
    });
  }

  Future pickDate(BuildContext context) async {
    //her change ini
    final initialDate = DateTime.now().add(Duration(days: 1));
    final newDate = await showDatePicker(
      // enablePastDates: false,
      context: context,
      initialDate: dateo ?? initialDate,
      firstDate: DateTime.now().add(Duration(days: 1)),
      //   DateTime(DateTime.now().day + 1),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return;
    Fluttertoast.showToast(
      msg: "Date selected.",
      toastLength: Toast.LENGTH_LONG,
    );
    setState(() => currdate = newDate.toString());
  }

  Future pickTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 9, minute: 0);
    final newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(), //ttime ?? initialTime

      //initialTime: document['date']
    );

    if (newTime == null) return;

    setState(() => currtime = newTime.toString());
    Fluttertoast.showToast(
      msg: "Time selected.",
      toastLength: Toast.LENGTH_LONG,
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
      value: item,
      child: Text(item,
          style: TextStyle(/*fontWeight: FontWeight.bold,*/ fontSize: 20)));
}
