import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:gather_go/services/database.dart';
import 'package:provider/provider.dart';
import 'package:gather_go/Models/NewUser.dart';
import 'package:gather_go/Models/EventInfo.dart';
import 'package:gather_go/shared/contants.dart';

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
  DateTime? ttime;
  GeoPoint? location;
  DateRangePickerController Datee = DateRangePickerController();

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
                      Text(
                        "Edit Your Profile",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: EventName,
                        initialValue: eventData?.name,
                        decoration: textInputDecoration.copyWith(
                            hintText: "What is the event ?"),
                        validator: (val) => val!.isEmpty ? "" : eventData?.name,
                        onChanged: (val) => setState(() => Name = val),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: EventDescription,
                        initialValue: eventData?.description,
                        decoration: textInputDecoration.copyWith(
                            hintText: "Tell us more about your event..."),
                        validator: (val) =>
                            val!.isEmpty ? "" : eventData?.description,
                        onChanged: (val) => setState(() => Description = val),
                      ),
                      SfDateRangePicker(
                        controller: Datee,
                        // onSelectionChanged: _onSelectionChanged,
                        selectionMode: DateRangePickerSelectionMode.single,
                        onSubmit: (val) =>
                            setState(() => dateo = val as DateTime),
                      ),
                      TimePickerSpinner(
                          is24HourMode: false,
                          normalTextStyle: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                              fontFamily: 'Comfortaa'),
                          highlightedTextStyle: TextStyle(
                            fontSize: 20,
                            color: Colors.orangeAccent,
                            fontFamily: 'Comfortaa',
                          ),
                          spacing: 50,
                          itemHeight: 40,
                          isForce2Digits: true,
                          onTimeChange: (time) {
                            setState(() {
                              ttime = time;
                            });
                          }),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.purple[300]),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white)),
                        child: Text('Save changes'),
                        onPressed: () async {
                          //update db here using stream provider and database class
                          if (dateo == null) {
                            print(ttime);
                            dateo = DateTime.now();
                          }
                          if (_formKey.currentState!.validate()) {
                            print(ttime);
                            await DatabaseService(uid: user?.uid).addEventData(
                                Name!,
                                Description!,
                                Timestamp.fromMicrosecondsSinceEpoch(
                                    dateo!.microsecondsSinceEpoch),
                                Timestamp.fromMicrosecondsSinceEpoch(ttime!
                                    .microsecondsSinceEpoch /*, location!*/),
                                false);
                          }
                        },
                      ),
                    ],
                  )));
        });
  }

// for date picker
//   Future pickDate(BuildContext context) async {
//     final initialDate = DateTime.now();
//     final newDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(DateTime.now().year),
//       lastDate: DateTime(DateTime.now().year + 5),
//     );

//     if (newDate == null) return;

//     setState(() => dateo = newDate);
//   }
// }

  // void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
  //   //// write here what will happen after select date
  //   // TODO: implement your code here

  // }
}
          // return Scaffold(
          //   appBar: AppBar(
          //     title: Text('New event ',
          //         style: TextStyle(
          //           fontFamily: 'Comfortaa',
          //           color: Colors.orangeAccent,
          //           fontWeight: FontWeight.bold,
          //           fontSize: 27,
          //         )),
          //     backgroundColor: Colors.white,
          //   ),
          //   body: Theme(
          //     data: ThemeData(
          //         accentColor: Colors.deepPurple,
          //         primarySwatch: Colors.deepPurple,
          //         colorScheme: ColorScheme.light(primary: Colors.orange)),
          //     child: Stepper(
          //         key: _formKey,
          //         // stepper for create event form 4 steps

          //         physics: ScrollPhysics(),
          //         currentStep: _currentStep,
          //         onStepTapped: (step) => tapped(step),
          //         onStepContinue: () => continued,
          //         onStepCancel: () => cancel,
          //         steps: <Step>[
          //           Step(
          //             isActive: _currentStep >= 0,
          //             title: Text('Event Name',
          //                 style: TextStyle(
          //                   fontFamily: 'Comfortaa',
          //                   color: Colors.deepPurple,
          //                   fontWeight: FontWeight.bold,
          //                 )),
          //             content: Container(
          //               child: TextFormField(
          //                 controller: name,
          //                 decoration: InputDecoration(
          //                   hintText: "What is the event ?",
          //                   enabledBorder: OutlineInputBorder(
          //                     borderRadius: BorderRadius.circular(20),
          //                     borderSide: BorderSide(
          //                       color: Colors.deepPurple,
          //                       width: 1.0,
          //                     ),
          //                   ),
          //                   focusedBorder: OutlineInputBorder(
          //                     borderRadius: BorderRadius.circular(20),
          //                     borderSide: BorderSide(
          //                       color: Colors.deepPurple,
          //                       width: 3.0,
          //                     ),
          //                   ),
          //                 ),
          //                 validator: (val) => val!.isEmpty
          //                     ? "Please enter your bio."
          //                     : eventData?.name,
          //                 onChanged: (val) => setState(() => Name = val),
          //               ),
          //             ),
          //           ),
          //           Step(
          //             isActive: _currentStep >= 1,
          //             title: Text('Event description',
          //                 style: TextStyle(
          //                   fontFamily: 'Comfortaa',
          //                   color: Colors.deepPurple,
          //                   fontWeight: FontWeight.bold,
          //                 )),
          //             content: Container(
          //               child: Padding(
          //                 padding: EdgeInsets.all(8.0),
          //                 child: TextFormField(
          //                     controller: description,
          //                     decoration: InputDecoration(
          //                       hintText: "Tell us more about your event...",
          //                       enabledBorder: OutlineInputBorder(
          //                         borderRadius: BorderRadius.circular(20),
          //                         borderSide: BorderSide(
          //                           color: Colors.deepPurple,
          //                           width: 1.0,
          //                         ),
          //                       ),
          //                       focusedBorder: OutlineInputBorder(
          //                         borderRadius: BorderRadius.circular(20),
          //                         borderSide: BorderSide(
          //                           color: Colors.deepPurple,
          //                           width: 3.0,
          //                         ),
          //                       ),
          //                     ),
          //                     maxLines: 8,
          //                     validator: (val) => val!.isEmpty
          //                         ? "Please enter your bio."
          //                         : eventData?.description,
          //                     onChanged: (val) =>
          //                         setState(() => Description = val)),
          //               ),
          //             ),
          //           ),
          //           Step(
          //             isActive: _currentStep >= 2,
          //             title: Text('Event date',
          //                 style: TextStyle(
          //                   fontFamily: 'Comfortaa',
          //                   color: Colors.deepPurple,
          //                   fontWeight: FontWeight.bold,
          //                 )),
                      // content: Container(
                      //   child: SfDateRangePicker(
                      //     controller: Datee,
                      //     //onSelectionChanged: _onSelectionChanged,
                      //     selectionMode: DateRangePickerSelectionMode.single,
                      //     onSubmit: (val) =>
                      //         setState(() => dateo = val as DateTime),
                      //   ),
          //             ),
          //           ),
          //           Step(
          //             isActive: _currentStep >= 3,
          //             title: Text('Event Time',
          //                 style: TextStyle(
          //                   fontFamily: 'Comfortaa',
          //                   color: Colors.deepPurple,
          //                   fontWeight: FontWeight.bold,
          //                 )),
          //             content: Container(
          //                 // color: Colors.deepOrange[50],
          //                 child: new TimePickerSpinner(
          //               is24HourMode: false,
          //               normalTextStyle: TextStyle(
          //                   fontSize: 15,
          //                   color: Colors.grey,
          //                   fontFamily: 'Comfortaa'),
          //               highlightedTextStyle: TextStyle(
          //                 fontSize: 20,
          //                 color: Colors.orangeAccent,
          //                 fontFamily: 'Comfortaa',
          //               ),
          //               spacing: 50,
          //               itemHeight: 40,
          //               isForce2Digits: true,
          //               onTimeChange: (time) {
          //                 setState(() {
          //                   ttime = time;
          //                 });
          //               },
          //             )),
          //           ),

          //           //Step(
          //           //isActive: _currentStep >= 4,
          //           //title: Text('Event location',
          //           // style: TextStyle(
          //           //  fontFamily: 'Comfortaa',
          //           //  color: Colors.deepPurple,
          //           // fontWeight: FontWeight.bold,
          //           //  )),
          //           //   content: Container(),
          //           //  )
          //         ]),
          //   ),
          // );
  //       });
  // }

  // tapped(int step) {
  //   setState(() => _currentStep = step);
  // }

  // continued(NewUser? user) async {
  //   _currentStep < 3
  //       ? setState(() => _currentStep += 1)
  //       : null; //number must change
  //   if (_currentStep == 4) {
  //     dynamic result =
  //         // if (_formKey.currentState!.validate())
  //         await DatabaseService(uid: user?.uid).addEventData(
  //             Name!, Description!, dateo!, ttime! /*, location!*/);
  //     if (result == null) {
  //       print("errrrror");
  //     }
  //   }
  // }

  // cancel() {
  //   _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  // }

  // for date picker
  // Future pickDate(BuildContext context) async {
  //   final initialDate = DateTime.now();
  //   final newDate = await showDatePicker(
  //     context: context,
  //     initialDate: date ?? initialDate,
  //     firstDate: DateTime(DateTime.now().year),
  //     lastDate: DateTime(DateTime.now().year + 5),
  //   );

  //   if (newDate == null) return;

  //   setState(() => date = newDate);
  // }

// }

// void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
//   //// write here what will happen after select date
//   // TODO: implement your code here
//
// }