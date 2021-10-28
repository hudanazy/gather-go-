import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gather_go/screens/home/edit_profile_form.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class imagePicker extends StatefulWidget {
  const imagePicker({Key? key}) : super(key: key);

  @override
  _imagePickerState createState() => _imagePickerState();
}

class _imagePickerState extends State<imagePicker> {
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(52),
        child: Column(
          children: [
            IconButton(
              padding: EdgeInsets.only(right: 270, top: 40),
//alignment: Alignment.topRight,
              // label: Text(
              //   "Set event date",
              //   style: TextStyle(
              //     color: Colors.deepPurple,
              //     fontSize: 20,
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),
              onPressed: () async {
                Navigator.pop(
                    context, MaterialPageRoute(builder: (context) => epForm()));
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 40,
              ),
            ),
            const SizedBox(height: 40),
            image != null
                ? ClipOval(
                    child: Image.file(image!,
                        width: 200, height: 200, fit: BoxFit.cover))
                : ClipOval(
                    child: Image.asset(
                      'images/profile.png',
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
            const SizedBox(
              height: 40,
            ),
            buildButton(
                title: "Pick from gallery",
                icon: Icons.image_outlined,
                onClicked: () {
                  pickImage(ImageSource.gallery);
                }),
            const SizedBox(
              height: 40,
            ),
            buildButton(
                title: "Take a photo",
                icon: Icons.camera_alt_outlined,
                onClicked: () {
                  pickImage(ImageSource.camera);
                }),
          ],
        ),
      ),
    );
  }

  Widget buildButton({
    required String title,
    required IconData icon,
    required VoidCallback onClicked,
  }) =>
      ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: Size.fromHeight(56),
            primary: Colors.orange[300],
            onPrimary: Colors.black,
            textStyle: TextStyle(fontSize: 20)),
        child: Row(
          children: [
            Icon(
              icon,
              size: 28,
            ),
            const SizedBox(
              width: 16,
            ),
            Text(title)
          ],
        ),
        onPressed: onClicked,
      );
}
