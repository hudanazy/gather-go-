import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gather_go/screens/myAppBar.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:gather_go/shared/num_button.dart';
import 'package:gather_go/services/database.dart';
import 'package:provider/provider.dart';
import 'package:gather_go/Models/NewUser.dart';
import 'package:gather_go/Models/EventInfo.dart';
import 'package:gather_go/shared/contants.dart';
import 'package:gather_go/shared/dialogs.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gather_go/screens/home/nav.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:io';

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
  TextEditingController attendeeNum = TextEditingController();

  //int _currentStep = 0;
  DateTime? dateo;
  TextEditingController? name;
  TextEditingController? description;
  String? Name;
  String? Description;
  int? attendeeNumber;
  TimeOfDay? ttime;
  GeoPoint? location;
  DateRangePickerController Datee = DateRangePickerController();
  String? timeAgo;
  int _currentValue = 0;
  bool approved = false;
  LatLng _initialcameraposition = LatLng(24.708481, 46.752108);
  late GoogleMapController _controller;

  List<Marker> myMarker = [];
  LatLng saveLatLng = LatLng(24.708481, 46.752108);
  String? StringLatLng;
  String viewDate = "Date ";
  String viewTime = "Time ";
  String viewLocation = "Location  ";
  var googleMap = GoogleMap(
      initialCameraPosition:
          CameraPosition(target: LatLng(24.708481, 46.752108)));
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

    return Scaffold(
<<<<<<< HEAD
        backgroundColor: Colors.white,
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
                          //               AppBar(

                          //   toolbarHeight: 100,
                          //   backgroundColor: Colors.white,
                          //   title: Text(
                          //     "Create An Event",
                          //     textAlign: TextAlign.center,
                          //     style: TextStyle(
                          //         color: Colors.black, fontFamily: 'Comfortaa', fontSize: 24),
                          //   ),
                          // ),
                          //   GradientAppBar(),

                          Stack(
                            children: [
                              Card(
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: image != null
                                    ? Image.file(image!,
                                        height: 160, fit: BoxFit.fill)
                                    : Image.asset(
                                        'images/evv.jpg',
                                        height: 200,
                                        fit: BoxFit.fill,
                                      ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
=======
      backgroundColor: Colors.white,
      appBar: MyAppBar(title: "Create An Event",),
      body:
     StreamBuilder<Object>(
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
                      
        //               AppBar(
                      
        //   toolbarHeight: 100,
        //   backgroundColor: Colors.white,
        //   title: Text(
        //     "Create An Event",
        //     textAlign: TextAlign.center,
        //     style: TextStyle(
        //         color: Colors.black, fontFamily: 'Comfortaa', fontSize: 24),
        //   ),
        // ),
                      //   GradientAppBar(),
                      Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(top: 20, left: 20),
                          child: Text(
                            "Event Name",
                            style: TextStyle(
                                color: Colors.orange[400],
                                letterSpacing: 2,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Comfortaa"),
                          ),
                        ),
                      SizedBox(height: 5),
                      SizedBox(
                        width: 350,
                        height: 50,
                        child: TextFormField(
                          controller: eventName,
                          maxLines: 1,
                          initialValue: eventData?.name,
                          decoration: 
                          textInputDecoration.copyWith(
                            
                          ),
                          validator: (val) => val!.trim().isEmpty
                              ? "The event needs a name."
                              : eventData?.name,
                          onChanged: (val) => setState(() => Name = val),
                        ),
                      ),
                      
                      Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(top: 20, left: 20),
                          child: Text(
                            "Event Category",
                            style: TextStyle(
                                color: Colors.orange[400],
                                letterSpacing: 2,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Comfortaa"),
                          ),
                        ),
                      

                      SizedBox(height: 5),
                      Container(
                        width: 350,
                        height: 50,
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.grey, width: 1)),
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
                                color: Colors.orange[400],
                                fontFamily: 'Comfortaa',
                              )),
                        ),
                      ),
                      
                      Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(top: 20, left: 20),
                          child: Text(
                            "Event Description",
                            style: TextStyle(
                                color: Colors.orange[400],
                                letterSpacing: 2,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Comfortaa"),
                          ),
                        ),
                      SizedBox(height: 5),
                      SizedBox(
                       
                        width: 350,
                        
                        child: TextFormField(
                          controller: eventDescription,
                          minLines: 3,
                          maxLines: 5,
                          initialValue: eventData?.description,
                          decoration: textInputDecoration.copyWith(),
                          validator: (val) => val!.trim().isEmpty
                              ? "Description can't be empty."
                              : eventData?.description,
                          onChanged: (val) => setState(() => Description = val),
                        ),
                      ),
                    
                      SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(top: 10, left: 20),
                        child: Text(
                          "Attendee Number",
                          style: TextStyle(
                              color: Colors.orange[400],
                              letterSpacing: 2,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Comfortaa"),
                        ),
                      ),
  NumericStepButton(
                        
                        minValue: 1,
                        maxValue: 500,
                        onChanged: (value) {
                            setState(() => this._currentValue = value);
                            }
                      ),
                      ],
                    ),
                      
                      
                      
                       
                       Center( child: 
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        RichText(
                        text: TextSpan(
                          children: [
                             WidgetSpan(
                              child: IconButton(
                               
                                icon: Icon(
                                  Icons.calendar_today_rounded,
                                  color: Colors.orange[400],
                                  size: 25,
>>>>>>> master
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

                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(top: 20, left: 20),
                            child: Text(
                              "Event Name",
                              style: TextStyle(
                                  color: Colors.orange[400],
                                  letterSpacing: 2,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Comfortaa"),
                            ),
                          ),
                          SizedBox(height: 5),
                          SizedBox(
                            width: 350,
                            height: 50,
                            child: TextFormField(
                              controller: eventName,
                              maxLines: 1,
                              initialValue: eventData?.name,
                              decoration: textInputDecoration.copyWith(),
                              validator: (val) => val!.trim().isEmpty
                                  ? "The event needs a name."
                                  : eventData?.name,
                              onChanged: (val) => setState(() => Name = val),
                            ),
                          ),

                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(top: 20, left: 20),
                            child: Text(
                              "Event Category",
                              style: TextStyle(
                                  color: Colors.orange[400],
                                  letterSpacing: 2,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Comfortaa"),
                            ),
                          ),

                          SizedBox(height: 5),
                          Container(
                            width: 350,
                            height: 50,
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: Colors.grey, width: 1)),
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
                                    color: Colors.orange[400],
                                    fontFamily: 'Comfortaa',
                                  )),
                            ),
                          ),

                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(top: 20, left: 20),
                            child: Text(
                              "Event Description",
                              style: TextStyle(
                                  color: Colors.orange[400],
                                  letterSpacing: 2,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Comfortaa"),
                            ),
                          ),
                          SizedBox(height: 5),
                          SizedBox(
                            width: 350,
                            child: TextFormField(
                              controller: eventDescription,
                              minLines: 3,
                              maxLines: 5,
                              initialValue: eventData?.description,
                              decoration: textInputDecoration.copyWith(),
                              validator: (val) => val!.trim().isEmpty
                                  ? "Description can't be empty."
                                  : eventData?.description,
                              onChanged: (val) =>
                                  setState(() => Description = val),
                            ),
                          ),

                          SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.only(top: 10, left: 20),
                                child: Text(
                                  "Attendee Number",
                                  style: TextStyle(
                                      color: Colors.orange[400],
                                      letterSpacing: 2,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Comfortaa"),
                                ),
                              ),
                              NumericStepButton(
                                  minValue: 1,
                                  maxValue: 500,
                                  onChanged: (value) {
                                    setState(() => this._currentValue = value);
                                  }),
                            ],
                          ),

                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.calendar_today_rounded,
                                            color: Colors.orange[400],
                                            size: 25,
                                          ),
                                          onPressed: () => pickDate(context),
                                        ),
                                      ),
                                      TextSpan(
                                        text: viewDate,
                                        style: TextStyle(
                                            color: Colors.orange[400],
                                            letterSpacing: 2,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Comfortaa"),
                                      ),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.access_time,
                                            textDirection: TextDirection.ltr,
                                            color: Colors.orange[400],
                                            size: 25,
                                          ),
                                          onPressed: () => pickTime(context),
                                        ),
                                      ),
                                      TextSpan(
                                        text: viewTime,
                                        style: TextStyle(
                                            color: Colors.orange[400],
                                            letterSpacing: 2,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Comfortaa"),
                                      ),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.location_on_outlined,
                                            textDirection: TextDirection.ltr,
                                            color: Colors.orange[400],
                                            size: 25,
                                          ),
                                          //Location()

                                          onPressed: () =>
                                              showMapdialogToSelectLocation(
                                                  context),
                                        ),
                                      ),
                                      TextSpan(
                                        text: viewLocation,
                                        style: TextStyle(
                                            color: Colors.orange[400],
                                            letterSpacing: 2,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Comfortaa"),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 10),

                          SizedBox(
                            height: 50,
                            width: 180,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.orange[400]),
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
                                    } else if (saveLat == 0 && saveLong == 0) {
                                      Fluttertoast.showToast(
                                        msg: "Location has to be selected.",
                                        toastLength: Toast.LENGTH_LONG,
                                      );
                                    } else if (_currentValue == 0) {
                                      Fluttertoast.showToast(
                                        msg: "Attendee number can't be 0 ",
                                        toastLength: Toast.LENGTH_LONG,
                                      );
                                    } else {
                                      // print(ttime);
                                      var result = await showMyDialog(context);

                                      if (result == true) {
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
                                                imageFile,
                                                dateo!);
                                        var userID = user.uid;
                                        await FirebaseMessaging.instance
                                            .subscribeToTopic('event_$userID');
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

  Future<bool> showMapdialogToSelectLocation(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("SELECT LOCATION",
                  style: TextStyle(color: Colors.grey, fontSize: 10)),
              content: SizedBox(
                height: 400,
                width: 450,
                child: GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: _initialcameraposition, zoom: 5),
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
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Done"),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      viewLocation = "Selected";
                      SizedBox(
                          height: 300,
                          width: 450,
                          child: googleMap = GoogleMap(
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
                          ));
                    });
                    if (saveLat != 0 && saveLat != 0)
                      Fluttertoast.showToast(
                        msg: "Location selected.",
                        toastLength: Toast.LENGTH_LONG,
                      );
                  },
                  child: Text("Click here to update the location "),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
