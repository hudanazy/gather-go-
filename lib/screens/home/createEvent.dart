import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class createEvent extends StatefulWidget {
  @override
  _Eventform createState() => _Eventform();
}

class _Eventform extends State<createEvent> {
  int _currentStep = 0;
  DateTime _dateTime = DateTime.now();
  TextEditingController EventName = TextEditingController();
  TextEditingController EventDescription = TextEditingController();
  DateRangePickerController EventDate = DateRangePickerController();

  //DateTime date;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New event ',
            style: TextStyle(
              fontFamily: 'Comfortaa',
              color: Colors.orangeAccent,
              fontWeight: FontWeight.bold,
              fontSize: 27,
            )),
        backgroundColor: Colors.white,
      ),
      body: Theme(
        data: ThemeData(
            accentColor: Colors.deepPurple,
            primarySwatch: Colors.deepPurple,
            colorScheme: ColorScheme.light(primary: Colors.orange)),
        child: Stepper(
            // stepper for create event form 4 steps

            physics: ScrollPhysics(),
            currentStep: _currentStep,
            onStepTapped: (step) => tapped(step),
            onStepContinue: continued,
            onStepCancel: cancel,
            steps: <Step>[
              Step(
                isActive: _currentStep >= 0,
                title: Text('Event Name',
                    style: TextStyle(
                      fontFamily: 'Comfortaa',
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    )),
                content: Container(
                  child: TextField(
                    controller: EventName,
                    decoration: InputDecoration(
                      hintText: "What is the event ?",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.deepPurple,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.deepPurple,
                          width: 3.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Step(
                isActive: _currentStep >= 1,
                title: Text('Event description',
                    style: TextStyle(
                      fontFamily: 'Comfortaa',
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    )),
                content: Container(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      controller: EventDescription,
                      decoration: InputDecoration(
                        hintText: "Tell us more about your event...",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.deepPurple,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.deepPurple,
                            width: 3.0,
                          ),
                        ),
                      ),
                      maxLines: 8,
                    ),
                  ),
                ),
              ),
              Step(
                isActive: _currentStep >= 2,
                title: Text('Event date',
                    style: TextStyle(
                      fontFamily: 'Comfortaa',
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    )),
                content: Container(
                  child: SfDateRangePicker(
                    controller: EventDate,
                    //onSelectionChanged: _onSelectionChanged,
                    selectionMode: DateRangePickerSelectionMode.single,
                  ),
                ),
              ),
              Step(
                isActive: _currentStep >= 3,
                title: Text('Event Time',
                    style: TextStyle(
                      fontFamily: 'Comfortaa',
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    )),
                content: Container(
                    // color: Colors.deepOrange[50],
                    child: new TimePickerSpinner(
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
                      _dateTime = time;
                    });
                  },
                )),
              ),
              //Step(
              //isActive: _currentStep >= 4,
              //title: Text('Event location',
              // style: TextStyle(
              //  fontFamily: 'Comfortaa',
              //  color: Colors.deepPurple,
              // fontWeight: FontWeight.bold,
              //  )),
              //   content: Container(),
              //  )
            ]),
      ),
    );
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 3
        ? setState(() => _currentStep += 1)
        : null; //number must change
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

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

}

// void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
//   //// write here what will happen after select date
//   // TODO: implement your code here
//
// }