import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gather_go/Models/EventInfo.dart';

import 'package:gather_go/screens/myAppBar.dart';

import 'package:gather_go/shared/dialogs.dart';
import 'package:geocoding/geocoding.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

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
    'Outdoor Activities',
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
  TextEditingController eventAttendee = TextEditingController();
  //int _currentStep = 0;
  DateTime? dateo;
  TextEditingController? name;
  TextEditingController? description;
  String? Description;
  TimeOfDay? ttime;
  GeoPoint? location;
  DateRangePickerController Datee = DateRangePickerController();
  String? timeAgo;
  bool approved = false;
  LatLng _initialcameraposition = LatLng(24.708481, 46.752108);
  late GoogleMapController _controller;

  List<Marker> myMarker = [];

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

    eventAttendee = TextEditingController.fromValue(
      TextEditingValue(text: widget.event!.get('attendees').toString()),
    );
  }

  @override
  void dispose() {
    eventName.dispose();
    super.dispose();
  }

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
  String? currentNameEvent = "";
  String? currentcatogary = "";
  String? currentDescrption = "";
  int? currattend = 0;
  String? currdate = "";
  DateTime? browseDate;
  String? browseDateString;
  String currtime = "";
  double? currentlat = 0.0;
  double? currentlong = 0.0;
  EventInfo? eventData;
  var googleMap = GoogleMap(
      initialCameraPosition:
          CameraPosition(target: LatLng(24.708481, 46.752108)));
  String viewLocation = "Location";
  String viewDate = "";

  int attendeeNum = 0;
  String attendeeNumString = "";
  bool ViewOrNot = true;
  bool ViewOrNot2 = true;
  bool ViewOrNot3 = true;

  String ViewTime = "";
  bool selectLocationTime = false;

  //final user = Provider.of<NewUser?>(context, listen: false);
  //DateTime date;
  @override
  Widget build(BuildContext context) {
    String oldCategory = widget.event?.get('category');
    String oldTime = widget.event?.get('time').substring(10, 15);
    String oldDate = widget.event?.get('date').substring(0, 10);
    if (!selected) {
      double oldLat = widget.event?.get('lat');
      double oldLong = widget.event?.get('long');
      pos(oldLat, oldLong);
    }
    viewLocation = areaName;
    if (currentcatogary != "") {
      ViewOrNot3 = false;
    }

    return selectLocationTime
        ? showMap(context)
        : Scaffold(
            appBar: SecondaryAppBar(
              title: "Edit your Event",
            ),
            // AppBar(
            //   leading: IconButton(
            //     icon: new Icon(
            //       Icons.arrow_back_ios,
            //       color: Colors.black,
            //     ),
            //     onPressed: () {
            //       Navigator.pop(
            //           context, MaterialPageRoute(builder: (context) => MyEvents()));
            //     },
            //   ),
            //   toolbarHeight: 100,
            //   backgroundColor: Colors.white,
            //   title: Text(
            //     "Edit your Event",
            //     textAlign: TextAlign.center,
            //     style: TextStyle(
            //         color: Colors.orange[300],
            //         fontFamily: 'Comfortaa',
            //         fontSize: 24),
            //   ),
            // ),
            body: SingleChildScrollView(
                child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Stack(
                              children: [
                                Card(
                                  semanticContainer: true,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: image != null
                                      ? Image.file(image!,
                                          height: 160, fit: BoxFit.fill)
                                      : widget.event?.get('imageUrl') != ''
                                          ? Ink.image(
                                              image: NetworkImage(
                                                widget.event?.get('imageUrl'),
                                              ),
                                              height: 160,
                                              width: 160,
                                              fit: BoxFit.fill,
                                              //width: 160,
                                            )
                                          : Image.asset(
                                              'images/evv.jpg',
                                              //   width: 200,
                                              height: 200,
                                              fit: BoxFit.fill,
                                            ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 5,
                                  margin: EdgeInsets.all(10),
                                ),
                                image != null ||
                                        widget.event?.get('imageUrl') != ''
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
                            /* Text(
                          "Edit your event",
                          style: TextStyle(
                              color: Colors.orange[600],
                              letterSpacing: 2,
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Comfortaa"),
                        ), */
                            SizedBox(
                              width: 350,
                              height: 50,
                              child: TextFormField(
                                controller: eventName,
                                initialValue: eventData?.name,
                                // initialValue: widget.event?.get('name'),
                                maxLines: 1,
                                decoration: InputDecoration(
                                  labelText: "Event Name ",
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
                                    setState(() => currentNameEvent = val),
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
                                    setState(() => currentDescrption = val),
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              width: 360,
                              height: 50,
                              padding: EdgeInsets.all(5),
                              child: DropdownButton<String>(
                                //ViewOrNot ? oldTime : ViewTime,
                                value: ViewOrNot3
                                    ? widget.event?.get('category')
                                    : currentcatogary,
                                focusColor: Colors.black,
                                isExpanded: true,
                                icon: Icon(Icons.arrow_drop_down,
                                    color: Colors.blueGrey),
                                items: category.map(buildMenuItem).toList(),
                                onChanged: (value) => setState(
                                    () => currentcatogary = value as String),
                                style: TextStyle(
                                  color: Colors.grey[850],
                                  fontFamily: 'Comfortaa',
                                  fontSize: 10,
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
                                controller: eventAttendee,
                                maxLines: 1,
                                initialValue: eventData?.attendees.toString(),
                                // widget.event?.get('attendees').toString(),
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
                                    ? "Attendess number can't be empty."
                                    : eventData?.description,
                                onChanged: (value) =>
                                    setState(() => attendeeNumString = value),
                                // maxLength: 4, attendeeNum
                              ),
                            ),
                            SizedBox(height: 5),
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
                                    ViewOrNot2 ? oldDate : viewDate,
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
                            SizedBox(height: 5),
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
                                    // 'hi',
                                    ViewOrNot ? oldTime : ViewTime,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Colors.grey[850],
                                        fontSize: 16,
                                        fontFamily: "Comfortaa"),
                                  )
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
                            SizedBox(height: 20),
                            SizedBox(
                              height: 48,
                              width: 360,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.orange[300]),
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
                                  if (image == null &&
                                      widget.event?.get('imageUrl') != '') {
                                    imageFile = widget.event?.get('imageUrl');
                                  }
                                  //image upload to storage
                                  else if (image != null) {
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

                                  ///print
                                  if (_formKey.currentState!.validate()) {
                                    // if (browseDateString == "") {
                                    //   browseDate = widget.event?.get('browseDate');
                                    // }
                                    if (currentNameEvent == "") {
                                      currentNameEvent =
                                          widget.event?.get('name');
                                    }
                                    if (currentDescrption == "") {
                                      currentDescrption =
                                          widget.event?.get('description');
                                    }

                                    if (currentcatogary == "") {
                                      currentcatogary =
                                          widget.event?.get('category');
                                    }
                                    if (attendeeNumString == "") {
                                      attendeeNum =
                                          widget.event?.get('attendees');
                                    }
                                    if (attendeeNumString != "") {
                                      attendeeNum =
                                          int.parse(attendeeNumString);
                                    }
                                    if (widget.event
                                            ?.get('browseDate')
                                            .toDate()
                                            .isBefore(DateTime.now()) &&
                                        browseDate == null) {
                                      Fluttertoast.showToast(
                                        msg:
                                            "You're date is in the past, you must change it ",
                                        toastLength: Toast.LENGTH_LONG,
                                      );
                                      return;
                                    }

                                    if (currdate == "") {
                                      currdate = widget.event?.get('date');
                                    }

                                    if (currtime == "") {
                                      currtime = widget.event?.get('time');
                                    }

                                    if (currentlat == 0.0 ||
                                        currentlong == 0.0) {
                                      currentlat = widget.event?.get('lat');
                                      currentlong = widget.event?.get('long');
                                    }
                                    var result =
                                        await showEditEventDialog(context);
                                    if (result == true) {
                                      try {
                                        List<String> searchDescription = [];
                                        String temp = "";
                                        for (var i = 0;
                                            i < currentDescrption!.length;
                                            i++) {
                                          if (currentDescrption![i] == " ") {
                                            temp = "";
                                          } else {
                                            temp = temp + currentDescrption![i];
                                            searchDescription
                                                .add(temp.toLowerCase());
                                          }
                                        }
                                        List<String> nameLowerCase = [];

                                        temp = "";
                                        for (var i = 0;
                                            i < currentNameEvent!.length;
                                            i++) {
                                          if (currentNameEvent![i] == " ") {
                                            temp = "";
                                          } else {
                                            temp = temp + currentNameEvent![i];
                                            nameLowerCase
                                                .add(temp.toLowerCase());
                                          }
                                        }
                                        if (browseDate == null) {
                                          FirebaseFirestore.instance
                                              .collection("events")
                                              .doc(widget.event?.id)
                                              .update({
                                            "name": currentNameEvent,
                                            "description": currentDescrption,
                                            "category": currentcatogary,
                                            "time": currtime,
                                            "lat": currentlat,
                                            "long": currentlong,
                                            "nameLowerCase": nameLowerCase,
                                            "searchDescription":
                                                searchDescription,
                                            "attendees": attendeeNum,
                                            "adminCheck": false,
                                            "imageUrl": imageFile
                                          });
                                        } else {
                                          FirebaseFirestore.instance
                                              .collection("events")
                                              .doc(widget.event?.id)
                                              .update({
                                            "name": currentNameEvent,
                                            "description": currentDescrption,
                                            "category": currentcatogary,
                                            "attendees": attendeeNum,
                                            "date": currdate,
                                            "time": currtime,
                                            "lat": currentlat,
                                            "long": currentlong,
                                            "nameLowerCase": nameLowerCase,
                                            "searchDescription":
                                                searchDescription,
                                            "browseDate": browseDate,
                                            "adminCheck": false,
                                            "imageUrl": imageFile
                                          });
                                        }

                                        // date
                                        int count = 2;
                                        Navigator.of(context)
                                            .popUntil((_) => count-- <= 0);
                                        //   Navigator.pop(context);
                                        Fluttertoast.showToast(
                                          msg: "Your Event update successfully",
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
    if (!selected) {
      currentlat = widget.event?.get('lat');
      currentlong = widget.event?.get('long');
      LatLng markerPosition = LatLng(currentlat!, currentlong!);
      myMarker.add(Marker(
          markerId: MarkerId(markerPosition.toString()),
          position: markerPosition,
          draggable: true,
          onDragEnd: (dragEndPosition) {
            print(dragEndPosition);
          }));
    }
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
      selected = true;
      pos(currentlat, currentlong);
      viewLocation = areaName;
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
    setState(() => browseDate = newDate);
    browseDateString = newDate.toString();

    viewDate = currdate.toString().substring(0, 10);
    ViewOrNot2 = false;
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
    ViewTime = currtime.toString().substring(10, 15);
    ViewOrNot = false;
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
      value: item,
      child: Text(item,
          style: TextStyle(/*fontWeight: FontWeight.bold,*/ fontSize: 20)));

  bool selected = false;
  Widget showMap(BuildContext context) {
    double oldLat = widget.event?.get('lat');
    double oldLong = widget.event?.get('long');
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Select Location ",
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Comfortaa',
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          elevation: 6,
          toolbarHeight: 100,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          actions: [
            IconButton(
                icon: const Icon(Icons.cancel, color: Colors.black, size: 27),
                onPressed: () {
                  setState(() {
                    selectLocationTime = false;
                    _handleTap(LatLng(oldLat, oldLong));
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
                          ? LatLng(oldLat, oldLong)
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
            Flex(direction: Axis.horizontal, children: <Widget>[
              Expanded(child: Text(address)),
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
                      'Ok ',
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
