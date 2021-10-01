import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:gather_go/services/database.dart';
import 'package:provider/provider.dart';
import 'package:gather_go/Models/NewUser.dart';
import 'package:gather_go/Models/EventInfo.dart';
import 'package:gather_go/shared/contants.dart';
import 'package:gather_go/shared/gradient_app_bar.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:gather_go/shared/dialogs.dart';

// ignore: camel_case_types
class createEvent extends StatefulWidget {
  @override
  _Eventform createState() => _Eventform();
}

class _Eventform extends State<createEvent> {
  final _formKey = GlobalKey<FormState>();

  DateTime _dateTime = DateTime.now();
  TextEditingController EventName = TextEditingController();
  TextEditingController EventDescription = TextEditingController();
  DateRangePickerController EventDate = DateRangePickerController();

  int _currentStep = 0;
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

  //DateTime date;
  @override
  Widget build(BuildContext context) {
    EventInfo? eventData;
    final user = Provider.of<NewUser?>(context, listen: false);

    return StreamBuilder<Object>(
        stream: DatabaseService(uid: user?.uid).events,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            eventData = snapshot.data as EventInfo;
          }
          return SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      // GradientAppBar(),
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(top: 20, left: 50),
                        child: Text(
                          "Event",
                          style: TextStyle(
                            color: Colors.deepOrange,
                            letterSpacing: 5,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: 320,
                        child: TextFormField(
                          controller: EventName,
                          maxLines: 2,
                          initialValue: eventData?.name,
                          decoration: textInputDecoration.copyWith(
                              hintText: "What is the event ?"),
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
                          "Description",
                          style: TextStyle(
                            color: Colors.purpleAccent,
                            letterSpacing: 5,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: 320,
                        child: TextFormField(
                          controller: EventDescription,
                          maxLines: 7,
                          initialValue: eventData?.description,
                          decoration: textInputDecoration.copyWith(
                              hintText: "Tell us more about your event..."),
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
                            color: Colors.blue,
                            letterSpacing: 5,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      NumberPicker(
                        value: _currentValue,
                        minValue: 1,
                        maxValue: 500,
                        onChanged: (value) =>
                            setState(() => _currentValue = value),
                      ),
                      Container(
                        color: Colors.amber,
                        width: 250,
                        child: TextButton.icon(
                          label: Text(
                            "Set event date",
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          icon: Icon(
                            Icons.calendar_today_outlined,
                            color: Colors.purpleAccent,
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size.fromHeight(40),
                            primary: Colors.white,
                          ),
                          onPressed: () => pickDate(context),
                        ),
                      ),
                      SizedBox(height: 20),
                      // SfDateRangePicker(
                      //   controller: Datee,
                      //   // onSelectionChanged: _onSelectionChanged,
                      //   selectionMode: DateRangePickerSelectionMode.single,
                      //   onSubmit: (val) =>
                      //       setState(() => dateo = val as DateTime),
                      // ),
                      Container(
                        color: Colors.amber,
                        width: 250,
                        child: TextButton.icon(
                          label: Text(
                            "Set event time",
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          icon: Icon(
                            Icons.hourglass_bottom_outlined,
                            textDirection: TextDirection.ltr,
                            color: Colors.purpleAccent,
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size.fromHeight(40),
                            primary: Colors.white,
                          ),
                          onPressed: () => pickTime(context),
                        ),
                      ),
                      SizedBox(height: 40),
                      SizedBox(
                        height: 50,
                        width: 180,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.purple[500],
                            shadowColor: Colors.purple[800],

                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            // backgroundColor:
                            //     MaterialStateProperty.all(Colors.purple[500]),
                            // foregroundColor:
                            //     MaterialStateProperty.all(Colors.white),
                          ),
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          onPressed: () async {
                            //update db here using stream provider and database class

                            timeAgo = DateTime.now().toString();
                            if (_formKey.currentState!.validate()) {
                              // print(ttime);
                              var result = await showMyDialog(context);
                              if (result == true) {
                                dynamic db =
                                    await DatabaseService(uid: user?.uid)
                                        .addEventData(
                                            user!.uid,
                                            Name!,
                                            Description!,
                                            timeAgo!,
                                            _currentValue,
                                            dateo.toString(),
                                            ttime.toString(),
                                            approved,
                                            false /*, location!*/);
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
  }
}
