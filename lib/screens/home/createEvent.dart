import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gather_go/screens/myAppBar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:gather_go/services/database.dart';
import 'package:provider/provider.dart';
import 'package:gather_go/Models/NewUser.dart';
import 'package:gather_go/Models/EventInfo.dart';
import 'package:gather_go/shared/dialogs.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gather_go/screens/home/nav.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:io';

// geo code
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'dart:async';

// ignore: camel_case_types
class createEvent extends StatefulWidget {
  @override
  _Eventform createState() => _Eventform();
}

class _Eventform extends State<createEvent> {
  final category = [
    'Select Event Category',
    'Educational',
    'Sports',
    'Arts',
    'Academic',
    'Culture',
    'Video Games',
    'Outdoor Activities',
    'Beauty',
    'Health',
    'Career',
    'Personal Growth',
    'Other',
  ];
  String? item = 'Select Event Category';

  final _formKey = GlobalKey<FormState>();

  //DateTime _dateTime = DateTime.now();
  TextEditingController eventName = TextEditingController();
  TextEditingController eventDescription = TextEditingController();
  TextEditingController attendeeNumber = TextEditingController();
  DateRangePickerController eventDate = DateRangePickerController();

  var attendeeNum;
  //int _currentStep = 0;
  DateTime? dateo;
  TextEditingController? name;
  TextEditingController? description;
  String? Name;
  String? Description;
  //int? attendeeNumber;
  TimeOfDay? ttime;
  GeoPoint? location;
  DateRangePickerController Datee = DateRangePickerController();
  String? timeAgo;
  int _currentValue = 0;
  bool approved = false;
  LatLng _initialcameraposition = LatLng(24.708481, 46.752108);
  late GoogleMapController _controller;
  bool selectLocationTime = false;
  List<Marker> myMarker = [];
  LatLng saveLatLng = LatLng(24.708481, 46.752108);
  String? StringLatLng;
  String viewDate = "Date ";
  String viewTime = "Time ";
  String viewLocation = "Location  ";

  var googleMap = GoogleMap(
      initialCameraPosition:
          CameraPosition(target: LatLng(24.708481, 46.752108)));

  bool selected = false;
  double saveLat = 0;
  double saveLong = 0;

  File? image;
  Future pickImage(ImageSource source) async {
    Future<File> saveImagePermanently(String imagePath) async {
      final directory = await getApplicationDocumentsDirectory();
      final name = basename(imagePath);
      final image = File('${directory.path}/$name');
      return File(imagePath).copy(image.path);
    }

    try {
      final image =
          await ImagePicker().pickImage(source: source, imageQuality: 50);
      if (image == null) return;

      // final imageTemporary = File(image.path);
      final imagePermanent = await saveImagePermanently(image.path);
      setState(() => this.image = imagePermanent);
    } on PlatformException catch (e) {
      print("Permission to access camera or gallery denied.");
      // TODO
    }
  }

  dynamic imageFile;
  //DateTime date;
  @override
  Widget build(BuildContext context) {
    EventInfo? eventData;
    final user = Provider.of<NewUser?>(context, listen: false);

// double v =widget.saveLat;
//selectLocationTime?showMap(context):Scaffold(
    return selectLocationTime
        ? showMap(context)
        : Scaffold(
            backgroundColor: Colors.white10,
            appBar: MyAppBar(
              title: "Create An Event",
            ),
            body: StreamBuilder<Object>(
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
                              SizedBox(
                                height: 30,
                              ),
                              // AppBar(
                              //   toolbarHeight: 80,
                              //   backgroundColor: Colors.white,
                              //   title: Text(
                              //     "Create Event",
                              //     textAlign: TextAlign.center,
                              //     style: TextStyle(
                              //         color: Colors.grey[850],
                              //         fontFamily: 'Comfortaa',
                              //         fontSize: 26,
                              //         fontWeight: FontWeight.w500),
                              //   ),
                              // ),
                              Stack(
                                children: [
                                  Card(
                                    semanticContainer: true,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: image != null
                                        ? Image.file(image!,
                                            height: 140, fit: BoxFit.fill)
                                        : Image.asset(
                                            'images/evv.jpg',
                                            height: 140,
                                            fit: BoxFit.fill,
                                          ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    elevation: 5,
                                    margin: EdgeInsets.all(10),
                                  ),
                                  image != null
                                      ? Positioned(
                                          left: 0,
                                          top: 0,
                                          bottom: 0,
                                          right: 0,
                                          child: buildEditIcon(Colors.white70),
                                        )
                                      : Positioned(
                                          left: 0,
                                          top: 0,
                                          bottom: 0,
                                          right: 0,
                                          child: buildEditIcon(Colors.black)),
                                ],
                              ),
                              SizedBox(height: 15),
                              SizedBox(
                                width: 350,
                                height: 50,
                                child: TextFormField(
                                  controller: eventName,
                                  maxLines: 1,
                                  // initialValue: eventData?.name,
                                  decoration: InputDecoration(
                                    labelText: "Event Name",
                                    labelStyle: (TextStyle(
                                        color: Colors.grey[850],
                                        fontFamily: "Comfortaa"
                                        //
                                        )),
                                  ),
                                  validator: (val) => val!.trim().isEmpty
                                      ? "The event needs a name."
                                      : eventData?.name,
                                  onChanged: (val) =>
                                      setState(() => Name = val),
                                ),
                              ),
                              SizedBox(height: 1),
                              SizedBox(
                                width: 350,
                                child: TextFormField(
                                  controller: eventDescription,
                                  minLines: 1,
                                  maxLines: 5,
                                  initialValue: eventData?.description,
                                  decoration: InputDecoration(
                                    labelText: "Event Description",
                                    labelStyle: (TextStyle(
                                        color: Colors.grey[850],
                                        // letterSpacing: 2,
                                        // fontSize: 13,
                                        // fontWeight: FontWeight.w600,
                                        fontFamily: "Comfortaa"
                                        //
                                        )),
                                  ),
                                  validator: (val) => val!.trim().isEmpty
                                      ? "Description can't be empty."
                                      : eventData?.description,
                                  onChanged: (val) =>
                                      setState(() => Description = val),
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                width: 360,
                                height: 50,

                                padding: EdgeInsets.all(5),
                                // color: Colors.black,
                                // decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(12),
                                //     border:
                                //         Border.all(color: Colors.grey, width: 1)),

                                child: DropdownButton<String>(
                                  value: item,
                                  focusColor: Colors.black,
                                  isExpanded: true,
                                  icon: Icon(Icons.arrow_drop_down,
                                      color: Colors.blueGrey),
                                  items: category.map(buildMenuItem).toList(),
                                  onChanged: (value) =>
                                      setState(() => this.item = value),
                                  style: TextStyle(
                                    color: Colors.grey[850],
                                    fontFamily: 'Comfortaa',
                                  ),
                                  hint: Text("Select Event Category",
                                      style: TextStyle(
                                          color: Colors.grey[850],
                                          fontFamily: "Comfortaa",
                                          fontSize: 16)),
                                ),
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                width: 350,
                                height: 50,
                                child: TextFormField(
                                  maxLines: 1,
                                  controller: attendeeNumber,
                                  decoration: InputDecoration(
                                    labelText: "Attendee Number",
                                    labelStyle: (TextStyle(
                                        color: Colors.grey[850],
                                        fontFamily: "Comfortaa"
                                        //
                                        )),
                                  ),
                                  keyboardType: TextInputType.datetime,
                                  validator: (val) => val!.trim().isEmpty
                                      ? "Attendee number can't be empty."
                                      : eventData?.description,
                                  onChanged: (val) =>
                                      setState(() => attendeeNum = val),
                                  // maxLength: 4,
                                ),
                              ),
                              Container(
                                  width: 370,
                                  height: 50,
                                  alignment: Alignment.bottomLeft,
                                  child: Row(children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.calendar_today_rounded,
                                        color: Colors.grey[850],
                                        size: 21,
                                      ),
                                      onPressed: () => pickDate(context),
                                    ),
                                    Text(
                                      viewDate,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.grey[850],
                                          fontSize: 16,
                                          fontFamily: "Comfortaa"),
                                    ),
                                  ])),
                              SizedBox(
                                  width: 350,
                                  height: 4,
                                  child: Divider(
                                    color: Colors.grey[500],
                                    thickness: 1.2,
                                  )),
                              Container(
                                  width: 370,
                                  height: 50,
                                  alignment: Alignment.bottomLeft,
                                  child: Row(children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.access_time,
                                        textDirection: TextDirection.ltr,
                                        color: Colors.grey[850],
                                        size: 22,
                                      ),
                                      onPressed: () => pickTime(context),
                                    ),
                                    Text(
                                      viewTime,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.grey[850],
                                          fontSize: 16,
                                          fontFamily: "Comfortaa"),
                                    ),
                                  ])),
                              SizedBox(
                                  width: 350,
                                  height: 4,
                                  child: Divider(
                                    color: Colors.grey[500],
                                    thickness: 1.2,
                                  )),
                              Container(
                                  width: 370,
                                  height: 50,
                                  alignment: Alignment.bottomLeft,
                                  child: Row(children: [
                                    IconButton(
                                        icon: Icon(
                                          Icons.location_on_outlined,
                                          textDirection: TextDirection.ltr,
                                          color: Colors.grey[850],
                                          size: 22,
                                        ),
                                        //Location()
                                        onPressed: () => setState(() {
                                              this.selectLocationTime = true;
                                            })),
                                    Text(
                                      viewLocation,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.grey[850],
                                          fontSize: 16,
                                          fontFamily: "Comfortaa"),
                                    ),
                                  ])),
                              SizedBox(
                                  width: 350,
                                  height: 4,
                                  child: Divider(
                                    color: Colors.grey[500],
                                    thickness: 1.2,
                                  )),
                              SizedBox(height: 20),
                              Center(),
                              SizedBox(
                                height: 47,
                                width: 360,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.orange[300]),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.fromLTRB(35, 15, 35, 15))),
                                  child: Text(
                                    'Submit',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Comfortaa"),
                                  ),
                                  onPressed: () async {
                                    //update db here using stream provider and database class
                                    if (item == null) {
                                      item = 'Other';
                                    } else {
                                      timeAgo = DateTime.now().toString();

//image upload to storage
                                      if (image != null) {
                                        final ref = FirebaseStorage.instance
                                            .ref()
                                            .child('event_image')
                                            .child(image.toString() + '.jpg');

                                        await ref.putFile(image!);

                                        final url = await ref.getDownloadURL();
                                        imageFile = url;
                                      } else {
                                        imageFile = '';
                                      }

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
                                        } else if (saveLat == 0 &&
                                            saveLong == 0) {
                                          Fluttertoast.showToast(
                                            msg: "Location has to be selected.",
                                            toastLength: Toast.LENGTH_LONG,
                                          );
                                        } else if (item ==
                                            "Select Event Category") {
                                          Fluttertoast.showToast(
                                            msg:
                                                "Event category has to be selected.",
                                            toastLength: Toast.LENGTH_LONG,
                                          );
                                        } else if (attendeeNum == "0") {
                                          Fluttertoast.showToast(
                                            msg: "Attendee number can't be 0 ",
                                            toastLength: Toast.LENGTH_LONG,
                                          );
                                        } else {
                                          // print(ttime);
                                          var result =
                                              await showMyDialog(context);

                                          if (result == true) {
                                            await DatabaseService(
                                                    uid: user?.uid)
                                                .addEventData(
                                                    user!.uid,
                                                    Name!,
                                                    item!,
                                                    Description!,
                                                    timeAgo!,
                                                    _currentValue =
                                                        int.parse(attendeeNum),
                                                    dateo.toString(),
                                                    ttime.toString(),
                                                    approved,
                                                    false,
                                                    saveLat,
                                                    saveLong,
                                                    imageFile,
                                                    dateo!);

                                            var userID = user.uid;
                                            await FirebaseMessaging.instance
                                                .subscribeToTopic(
                                                    'event_$userID');
                                            Fluttertoast.showToast(
                                              msg:
                                                  "Event successfully sent to admin.",
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
                }));
  }

  Widget buildEditIcon(Color color) => InkWell(
      onTap: () {
        //imagePicker();
        pickImage(ImageSource.gallery);
      },
      child: buildCircle(
        color: Colors.transparent,
        all: 3,
        child: buildCircle(
          color: Colors.transparent,
          all: 8,
          child: Icon(
            Icons.camera_alt_sharp,
            color: color.withOpacity(0.4),
            size: 50,
          ),
        ),
      ));
  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
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
      selected = true;
      pos(saveLat, saveLong);
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
    viewDate = newDate.toString().substring(0, 10);
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
    viewTime = ttime.toString().substring(10, 15);
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
      value: item,
      child: Text(item,
          style: TextStyle(/*fontWeight: FontWeight.bold,*/ fontSize: 20)));

  Widget showMap(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Select Location",
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Comfortaa',
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          elevation: 6,
          toolbarHeight: 100,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          actions: [
            IconButton(
                icon: const Icon(Icons.cancel, color: Colors.black, size: 27),
                onPressed: () {
                  setState(() {
                    selectLocationTime = false;
                  });
                }),
          ],
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(
                height: 450,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: !selected
                          ? LatLng(24.708481, 46.752108)
                          : LatLng(saveLat, saveLong),
                      zoom: 15),
                  mapType: MapType.normal,
                  onMapCreated: _onMapCreated,
                  rotateGesturesEnabled: true,
                  scrollGesturesEnabled: true,
                  zoomControlsEnabled: true,
                  zoomGesturesEnabled: true,
                  liteModeEnabled: false,
                  indoorViewEnabled: true,
                  tiltGesturesEnabled: true,
                  myLocationEnabled: true,
                  markers: Set.from(myMarker),
                  onTap: _handleTap,
                ),
              ),
            ),
            !selected
                ? Container()
                : Flex(direction: Axis.horizontal, children: <Widget>[
                    Expanded(child: Text('$address ')),
                    Padding(
                        padding: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.orange[300]),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.fromLTRB(35, 15, 35, 15))),
                          child: Text(
                            'Ok',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Comfortaa"),
                          ),
                          onPressed: () {
                            setState(() {
                              selectLocationTime = false;
                            });
                          },
                        )),
                  ]),
          ],
        ));
  }

  String address = '';
  String areaName = '';
  Future<String?> pos(lat, long) async {
    List<Placemark> newPlace = await placemarkFromCoordinates(lat, long);

    Placemark placeMark = newPlace[0];
    String? name = placeMark.name;
    String? subLocality = placeMark.subLocality;
    String? locality = placeMark.locality;
    String? administrativeArea = placeMark.administrativeArea;
    String? postalCode = placeMark.postalCode;
    String? country = placeMark.country;
    setState(() {
      address =
          "$name, $subLocality, $locality, $administrativeArea, $postalCode, $country";

      areaName = "$locality , $subLocality";
      viewLocation = areaName;
    });
    String? location;
    String? area;
    int index;
    if (locality != "") {
      location = locality.toString();
    } else {
      location = administrativeArea.toString();
    }
    return location;
  }
}
