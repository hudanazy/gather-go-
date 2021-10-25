import 'package:flutter/material.dart';
import 'package:gather_go/Models/ProfileOnScreen.dart';
import 'package:gather_go/Models/UesrInfo.dart';
import 'package:gather_go/services/database.dart';
import 'package:gather_go/shared/contants.dart';
import 'package:provider/provider.dart';
import 'package:gather_go/Models/NewUser.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gather_go/shared/profile_widget.dart';

class epForm extends StatefulWidget {
  const epForm({Key? key}) : super(key: key);

  @override
  _epFormState createState() => _epFormState();
}

class _epFormState extends State<epForm> {
  final _formkey = GlobalKey<FormState>();
  final List<String> status = [
    'Available',
    'Busy',
    'At School',
    'At Work',
    'In a meeting',
    'Sleeping',
    'Away'
  ];

  String? _currentName;
  String? _currentBio;
  String? _currentStatus = "Available";

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<NewUser?>(context);
    return StreamBuilder<UesrInfo>(
        stream: DatabaseService(uid: user?.uid).profileData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UesrInfo profileData = snapshot.data as UesrInfo;
          }
          return Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Edit your profile",
                  style: TextStyle(
                      color: Colors.orange[600],
                      letterSpacing: 2,
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Comfortaa"),
                ),
                SizedBox(
                  height: 30,
                ),
                ProfileWidget(
                  imagePath: "https://picsum.photos/200/300",
//document['name'],
                  isEdit: true,
                  onClicked: () async {
                    // _showProfilePanel();
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: 320,
                  child: TextFormField(
                    //initialValue: profileData.name,
                    decoration: textInputDecoration.copyWith(
                      hintText: "What would like us to call you?",
                      hintStyle: TextStyle(
                          color: Colors.orange[600],
                          fontSize: 14,
                          fontFamily: "Comfortaa"),
                    ),
                    validator: (val) =>
                        val!.isEmpty ? 'Please enter a name' : null,
                    onChanged: (val) => setState(() => _currentName = val),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(top: 0, left: 5),
                  child: Text(
                    "How many attendees?",
                    style: TextStyle(
                        color: Colors.orange[600],
                        letterSpacing: 2,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Comfortaa"),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField(
                  value: _currentStatus ?? "Available",
                  decoration: textInputDecoration,
                  items: status.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (val) =>
                      setState(() => _currentStatus = val as String),
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: 320,
                  child: TextFormField(
                    decoration: textInputDecoration.copyWith(
                      hintText: "Enter your bio.",
                      hintStyle: TextStyle(
                          color: Colors.orange[600],
                          fontSize: 14,
                          fontFamily: "Comfortaa"),
                    ),
                    maxLines: 4,
                    validator: (val) =>
                        val!.isEmpty ? 'Please enter a bio' : null,
                    onChanged: (val) => setState(() => _currentBio = val),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 50,
                  width: 190,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.orange[400]),
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
                      if (_formkey.currentState!.validate()) {
                        dynamic db = await DatabaseService(uid: user?.uid)
                            .updateProfileData(user!.uid, _currentName!,
                                _currentStatus!, _currentBio!);
                        Navigator.pop(context);
                        Fluttertoast.showToast(
                          msg: "Profile successfully updated.",
                          toastLength: Toast.LENGTH_LONG,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget buildImage() {
    final image = NetworkImage("https://picsum.photos/200/300");

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
          child: InkWell(onTap: () {}),
        ),
      ),
    );
  }
}
