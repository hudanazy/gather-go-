import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gather_go/Models/EventInfo.dart';
import 'package:gather_go/screens/home/MyEvents.dart';
import 'package:gather_go/screens/myAppBar.dart';
import 'package:gather_go/shared/contants.dart';
import 'package:gather_go/shared/dialogs.dart';
import 'package:gather_go/shared/num_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../NotifactionManager.dart';
import 'MyEventsDetails.dart';
import 'nav.dart';
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
  String? currtime = "";
  double? currentlat = 0.0;
  double? currentlong = 0.0;
  EventInfo? eventData;
  var googleMap = GoogleMap(
      initialCameraPosition:
          CameraPosition(target: LatLng(24.708481, 46.752108)));
  String viewLocation = "Location";
  String viewDate = " Date ";
  String viewTime = "";

  //final user = Provider.of<NewUser?>(context, listen: false);
  //DateTime date;
  @override
  Widget build(BuildContext context) {
    bool adminCheck = widget.event?.get('adminCheck');
    bool approved = widget.event?.get('approved'); //111111111
    int attendeeNum = widget.event?.get('attendees');
    String userID = widget.event?.get('uid');
    String oldTime = widget.event?.get('time');

    return Scaffold(
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
        //         color: Colors.orange[400],
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
                            image != null || widget.event?.get('imageUrl') != ''
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
                          child: TextFormField(
                            maxLines: 1,
                            initialValue: widget.event?.get('name'),

                            decoration: textInputDecoration.copyWith(
                              hintText: "Event name..",
                              hintStyle: TextStyle(
                                  color: Colors.orange[400],
                                  fontFamily: "Comfortaa"),
                            ),

                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Comfortaa',
                            ),
                            validator: (val) => val!.trim().isEmpty
                                ? 'Please enter a name'
                                : null,
                            onChanged: (val) {
                              setState(() => currentNameEvent = val);
                            }, //name event
                          ),
                        ),
                        SizedBox(
                          height: 5,
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
                        SizedBox(height: 10),
                        Container(
                          width: 350,
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
                          height: 5,
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
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: 350,
                          child: TextFormField(
                            maxLines: 5,
                            initialValue: widget.event?.get('description'),
                            decoration: textInputDecoration.copyWith(
                                hintText: "Tell us more about your event...",
                                hintStyle: TextStyle(
                                    color: Colors.orange[400],
                                    fontFamily: "Comfortaa")),
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Comfortaa',
                            ),
                            validator: (val) => val!.trim().isEmpty
                                ? 'Please enter a descrption about event '
                                : null,
                            onChanged: (val) {
                              setState(() => currentDescrption = val);
                            },
                          ),
                        ),
                        SizedBox(height: 5),
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

                        //-------------------------------------------time
                        SizedBox(height: 5),
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
                                      text:
                                          viewTime.isEmpty ? oldTime : viewTime,
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
                        SizedBox(height: 20),

                        SizedBox(
                          height: 50,
                          width: 115,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.orange[400]),
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.fromLTRB(35, 15, 35, 15))),
                            child: Text(
                              'Save',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "Comfortaa"),
                            ),
                            onPressed: () async {
                              // print("hi im here 1 $Name");
                              if (image == null &&
                                  widget.event?.get('imageUrl') == '') {
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
                                        nameLowerCase.add(temp.toLowerCase());
                                      }
                                    }
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
                                      "nameLowerCase": nameLowerCase,
                                      "searchDescription": searchDescription,
                                      "browseDate": browseDate
                                    });

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
    setState(() => browseDate = newDate);

    viewDate = currdate.toString().substring(0, 10);
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
    viewTime = currtime.toString().substring(10, 15);
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
