import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:gather_go/screens/home/event_list.dart';
// import 'package:gather_go/screens/home/profile_form.dart';
// import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
//import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:gather_go/services/database.dart';
import 'package:provider/provider.dart';
import 'package:gather_go/Models/NewUser.dart';
import 'package:gather_go/Models/EventInfo.dart';
import 'package:gather_go/shared/contants.dart';
//import 'package:gather_go/shared/gradient_app_bar.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:gather_go/shared/dialogs.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:gather_go/screens/home/home.dart';
import 'package:gather_go/screens/home/nav.dart';
//import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:gather_go/shared/num_button.dart';
import '../NotifactionManager.dart';
//import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

// ignore: camel_case_types
class createEvent extends StatefulWidget {
  @override
  _Eventform createState() => _Eventform();
}

class _Eventform extends State<createEvent> {
  final category = [
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
  TextEditingController eventName = TextEditingController();
  TextEditingController eventDescription = TextEditingController();
  DateRangePickerController eventDate = DateRangePickerController();

  //int _currentStep = 0;
  DateTime? dateo;
  TextEditingController? name;
  TextEditingController? description;
  String? Name;
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

    tz.initializeTimeZones();
  }

  //DateTime date;
  @override
  Widget build(BuildContext context) {
    EventInfo? eventData;
    final user = Provider.of<NewUser?>(context, listen: false);

    return StreamBuilder<Object>(
        stream: DatabaseService(uid: user?.uid).eventss,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            eventData = snapshot.data as EventInfo;
          }
          return SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 30),
                      AppBar(
                        backgroundColor: Colors.white,
                        elevation: 0.0,
                        title: Text(
                          "Create an event",
                          style: TextStyle(
                            fontFamily: 'Comfortaa',
                            fontSize: 27,
                            color: Colors.orange[600],
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      //   GradientAppBar(),
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(top: 20, left: 50),
                        // child: Text(
                        //   "Event Nme",
                        //   style: TextStyle(
                        //     color: Colors.purpleAccent,
                        //     letterSpacing: 5,
                        //     fontSize: 20,
                        //     fontWeight: FontWeight.w700,
                        //   ),
                        // ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: 320,
                        child: TextFormField(
                          controller: eventName,
                          maxLines: 1,
                          initialValue: eventData?.name,
                          decoration: textInputDecoration.copyWith(
                            hintText: "Event name..",
                            hintStyle: TextStyle(
                                color: Colors.orange[600],
                                fontFamily: "Comfortaa"),
                          ),
                          validator: (val) => val!.isEmpty
                              ? "The event needs a name."
                              : eventData?.name,
                          onChanged: (val) => setState(() => Name = val),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(top: 20, left: 50),
                        child: Text(
                          "Event Category",
                          style: TextStyle(
                              color: Colors.orange[600],
                              letterSpacing: 2,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Comfortaa"),
                        ),
                      ),

                      SizedBox(height: 10),
                      Container(
                        width: 320,
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.amberAccent, width: 2)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                              focusColor: Colors.grey,
                              value: item,

                              // initialValue: category[0],
                              isExpanded: true,
                              icon: Icon(Icons.arrow_drop_down,
                                  color: Colors.blueGrey),
                              items: category.map(buildMenuItem).toList(),
                              onChanged: (value) =>
                                  setState(() => this.item = value),
                              style: TextStyle(
                                color: Colors.orange[600],
                                fontFamily: 'Comfortaa',
                              )),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(top: 20, left: 50),
                        // child: Text(
                        //   "Description",
                        //   style: TextStyle(
                        //     color: Colors.lightBlue,
                        //     letterSpacing: 5,
                        //     fontSize: 20,
                        //     fontWeight: FontWeight.w700,
                        //   ),
                        // ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: 320,
                        child: TextFormField(
                          controller: eventDescription,
                          maxLines: 5,
                          initialValue: eventData?.description,
                          decoration: textInputDecoration.copyWith(
                              hintText: "Tell us more about your event...",
                              hintStyle: TextStyle(
                                  color: Colors.orange[600],
                                  fontFamily: "Comfortaa")),
                          validator: (val) => val!.isEmpty
                              ? "Description can't be empty."
                              : eventData?.description,
                          onChanged: (val) => setState(() => Description = val),
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
                      // NumericStepButton(
                      //   // value: _currentValue,
                      //   minValue: 1,
                      //   maxValue: 500,
                      //   onChanged: (value) =>
                      //       setState(() => this._currentValue = value),
                      // ),
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
                              text: "Select date ",
                              style: TextStyle(
                                  color: Colors.orange[600],
                                  letterSpacing: 2,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Comfortaa"),
                            ),
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
                      // Container(
                      //   // color: Colors.amber,
                      //   width: 50,
                      // child: IconButton(
                      //   // label: Text(
                      //   //   "Set event date",
                      //   //   style: TextStyle(
                      //   //     color: Colors.deepPurple,
                      //   //     fontSize: 20,
                      //   //     fontWeight: FontWeight.w500,
                      //   //   ),
                      //   // ),
                      //   icon: Icon(
                      //     Icons.calendar_today_rounded,
                      //     color: Colors.purple[300],
                      //     size: 50,
                      //   ),
                      //   // style: ElevatedButton.styleFrom(
                      //   //   minimumSize: Size.fromHeight(40),
                      //   //   primary: Colors.white,
                      //   // ),
                      //   onPressed: () => pickDate(context),
                      // ),
                      // ),
                      SizedBox(height: 20),
                      // SfDateRangePicker(
                      //   controller: Datee,
                      //   // onSelectionChanged: _onSelectionChanged,
                      //   selectionMode: DateRangePickerSelectionMode.single,
                      //   onSubmit: (val) =>
                      //       setState(() => dateo = val as DateTime),
                      // ),
                      // Container(
                      //   margin: const EdgeInsets.only(right: 5.0),
                      //   // color: Colors.amber,
                      //   width: 50,
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Select time ",
                              style: TextStyle(
                                  color: Colors.orange[600],
                                  letterSpacing: 2,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Comfortaa"),
                            ),
                            WidgetSpan(
                              child: IconButton(
                                // label: Text(
                                //   "Set event time",
                                //   style: TextStyle(
                                //     color: Colors.deepPurple,
                                //     fontSize: 20,
                                //     fontWeight: FontWeight.w500,
                                //   ),
                                // ),
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
                      // child: IconButton(
                      //   // label: Text(
                      //   //   "Set event time",
                      //   //   style: TextStyle(
                      //   //     color: Colors.deepPurple,
                      //   //     fontSize: 20,
                      //   //     fontWeight: FontWeight.w500,
                      //   //   ),
                      //   // ),
                      //   icon: Icon(
                      //     Icons.access_time,
                      //     textDirection: TextDirection.ltr,
                      //     color: Colors.purple[300],
                      //     size: 50,
                      //   ),
                      //   // style: ElevatedButton.styleFrom(
                      //   //    minimumSize: Size.fromHeight(40),
                      //   //   primary: Colors.white,
                      //   // ),
                      //   onPressed: () => pickTime(context),
                      // ),

                      SizedBox(height: 40),
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(top: 20, left: 50),
                        child: Text(
                          "Select location",
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
                      SizedBox(height: 40),

                      SizedBox(
                        height: 50,
                        width: 180,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.orange[400]),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.fromLTRB(35, 15, 35, 15))),
                          child: Text(
                            'Submit',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Comfortaa"),
                          ),
                          onPressed: () async {
                            //update db here using stream provider and database class
                            if (item == null) {
                              item = 'Other';
                            } else {
                              timeAgo = DateTime.now().toString();
                              if (_formKey.currentState!.validate()) {
                                if (dateo == null &&
                                    ttime == null &&
                                    saveLat == 0 &&
                                    saveLong == 0) {
                                  Fluttertoast.showToast(
                                    msg:
                                        "Date and time and location have to be selected.",
                                    toastLength: Toast.LENGTH_LONG,
                                  );
                                } else if (dateo == null) {
                                  Fluttertoast.showToast(
                                    msg: "Date has to be selected.",
                                    toastLength: Toast.LENGTH_LONG,
                                  );
                                } else if (ttime == null) {
                                  Fluttertoast.showToast(
                                    msg: "Time has to be selected.",
                                    toastLength: Toast.LENGTH_LONG,
                                  );
                                } else if (saveLat == 0 && saveLong == 0) {
                                  Fluttertoast.showToast(
                                    msg: "Location has to be selected.",
                                    toastLength: Toast.LENGTH_LONG,
                                  );
                                } else {
                                  // print(ttime);
                                  var result = await showMyDialog(context);
                                  if (result == true) {
                                    // NotifactionManager().showNotification(
                                    //     1,
                                    //     "Reminder, " + eventName.text,
                                    //     "You have upcoming event, don't forget it",
                                    //     dateo,
                                    //     ttime); //before 1 day
                                    await DatabaseService(uid: user?.uid)
                                        .addEventData(
                                      user!.uid,
                                      Name!,
                                      item!,
                                      Description!,
                                      timeAgo!,
                                      _currentValue,
                                      dateo.toString(),
                                      ttime.toString(),
                                      approved,
                                      false,
                                      saveLat,
                                      saveLong,
                                    );
                                    var userID = user.uid;
                                    await FirebaseMessaging.instance.subscribeToTopic('event_$userID$timeAgo');
                                    Fluttertoast.showToast(
                                      msg: "Event successfully sent to admin.",
                                      toastLength: Toast.LENGTH_LONG,
                                    );
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MyBottomBarDemo()));
                                  }
                                }
                              }
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 40),
                    ],
                  )));
        });
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
      saveLat = tappedPoint.latitude;
      saveLong = tappedPoint.longitude;
    });
  }

  Future pickDate(BuildContext context) async {
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
    setState(() => dateo = newDate);
  }

  Future pickTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 9, minute: 0);
    final newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now() //ttime ?? initialTime
      ,
    );

    if (newTime == null) return;

    setState(() => ttime = newTime);
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
