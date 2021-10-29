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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gather_go/shared/loading.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

  @override
  Widget build(BuildContext context) {
    //  final user = Provider.of<NewUser?>(context);
    UesrInfo? profileData;
    final user = Provider.of<NewUser?>(context, listen: false);

    Stream<QuerySnapshot<Map<String, dynamic>>> snap = FirebaseFirestore
        .instance
        .collection('uesrInfo')
        .where('uid', isEqualTo: user?.uid)
        .snapshots();

    return StreamBuilder<Object>(
        stream: snap, //DatabaseService(uid: user.uid).profileData,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Loading(),
              //     child: Text(
              //   "No New Events", // may be change it to loading , itis appear for a second every time
              //   textAlign: TextAlign.center,
              // )
            );
          }
          return Container(
              // height: 640,
              // width: 500,
              child: ListView(
            children: snapshot.data.docs.map<Widget>((document) {
              DocumentSnapshot uid = document;
              String? _currentName = document['name'];
              String? _currentBio = document['bio'];
              String? _currentStatus = document['status'];
              File? _imageFile;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
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
                            ClipOval(
                                child: Material(
                              color: Colors.transparent,
                              child: image != null
                                  ? Image.file(image!,
                                      width: 160,
                                      height: 160,
                                      fit: BoxFit.cover)
                                  : document['imageUrl'] != ''
                                      ? Ink.image(
                                          image: NetworkImage(
                                              document['imageUrl']),
                                          fit: BoxFit.cover,
                                          width: 160,
                                          height: 160,
                                        )
                                      : Image.asset(
                                          'images/profile.png',
                                          width: 200,
                                          height: 200,
                                          fit: BoxFit.cover,
                                        ),
                            )),
                            image != null || document['imageUrl'] != ''
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
                          initialValue: document['name'],
                          decoration: textInputDecoration.copyWith(
                            hintText: "What would like us to call you?",
                            hintStyle: TextStyle(
                                color: Colors.orange[600],
                                fontSize: 14,
                                fontFamily: "Comfortaa"),
                          ),
                          style: TextStyle(
                              color: Colors.orange[600],
                              fontSize: 14,
                              fontFamily: "Comfortaa"),
                          validator: (val) =>
                              val!.isEmpty ? 'Please enter a name' : null,
                          onChanged: (val) =>
                              setState(() => _currentName = val),
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
                          value: _currentStatus,
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
                          initialValue: document['bio'],
                          decoration: textInputDecoration.copyWith(
                            hintText: "Enter your bio.",
                            hintStyle: TextStyle(
                                color: Colors.orange[600],
                                fontSize: 14,
                                fontFamily: "Comfortaa"),
                          ),
                          maxLines: 4,
                          style: TextStyle(
                              color: Colors.orange[600],
                              fontSize: 14,
                              fontFamily: "Comfortaa"),
                          validator: (val) =>
                              val!.isEmpty ? 'Please enter a bio' : null,
                          onChanged: (val) => setState(() => _currentBio = val),
                        ),
                      ),
                      SizedBox(
                        height: 10,
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
                            if (image == null) {
                              Fluttertoast.showToast(
                                msg: "Please pick an image.",
                                toastLength: Toast.LENGTH_LONG,
                              );
                              return;
                            }
                            //image upload to storage

                            if (_formkey.currentState!.validate()) {
                              final ref = FirebaseStorage.instance
                                  .ref()
                                  .child('user_image')
                                  .child(user!.uid + '.jpg');

                              await ref.putFile(image!);
                              final url = await ref.getDownloadURL();

                              dynamic db = await DatabaseService(uid: user.uid)
                                  .updateProfileData(user.uid, _currentName!,
                                      _currentStatus!, _currentBio!, url);
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
                ),
              );
            }).toList(),
          ));
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
