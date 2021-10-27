import 'package:flutter/material.dart';
import 'package:gather_go/Models/ProfileOnScreen.dart';
import 'package:gather_go/Models/UesrInfo.dart';
import 'package:gather_go/services/database.dart';
import 'package:gather_go/shared/contants.dart';
import 'package:provider/provider.dart';
import 'package:gather_go/Models/NewUser.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gather_go/shared/profile_widget.dart';
import 'package:gather_go/shared/image_picker.dart';
import 'dart:io';

import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

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
  File? _imageFile;

  File? image;
  Future pickImage(ImageSource source) async {
    Future<File> saveImagePermanently(String imagePath) async {
      final directory = await getApplicationDocumentsDirectory();
      final name = basename(imagePath);
      final image = File('${directory.path}/$name');
      return File(imagePath).copy(image.path);
    }

    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      // final imageTemporary = File(image.path);
      final imagePermanent = await saveImagePermanently(image.path);
      setState(() => this.image = imagePermanent);
    } on PlatformException catch (e) {
      print("Permission to access camera or gallery denied.");
      // TODO
    }
  }

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
                  height: 20,
                ),
                Center(
                  child: Stack(
                    children: [
                      image != null
                          ? ClipOval(
                              child: Image.file(image!,
                                  width: 160, height: 160, fit: BoxFit.cover))
                          : ClipOval(
                              child: Image.asset(
                                'images/profile.png',
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                      image != null
                          ? Positioned(
                              bottom: 0,
                              right: 4,
                              child: buildEditIcon(Colors.blue),
                            )
                          : Positioned(
                              bottom: 15,
                              right: 15,
                              child: buildEditIcon(Colors.blue))
                    ],
                  ),
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
                    "Status",
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
                    style: TextStyle(
                      color: Colors.orange[600],
                      fontFamily: 'Comfortaa',
                    )),
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
                                _currentStatus!, _currentBio!, _imageFile!);
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

  Widget buildEditIcon(Color color) => InkWell(
      onTap: () {
        //imagePicker();
        pickImage(ImageSource.gallery);
      },
      child: buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: Icon(
            Icons.camera_alt_outlined,
            color: Colors.white,
            size: 25,
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
}
