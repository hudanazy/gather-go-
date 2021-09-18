import 'package:flutter/material.dart';
import 'package:gather_go/Models/UserOnScreen.dart';
import 'package:gather_go/services/database.dart';
import 'package:gather_go/shared/contants.dart';
import 'package:gather_go/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:gather_go/Models/NewUser.dart';

class ProfileForm extends StatefulWidget {
  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>(); //for form

  String? _currentName;
  String? _currentBio;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<NewUser?>(
        context); //storing user (before we made snapshot method in database class
    //then made userData class(in UserOnScreen file) then access user data snapshot here in form) tut.25
    UserData? userData;

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user?.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            userData = snapshot.data;
          }

          return Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text(
                    "Edit Your Profile",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    initialValue: userData?.name,
                    decoration:
                        textInputDecoration.copyWith(hintText: "Username"),
                    validator: (val) => val!.isEmpty
                        ? "Please enter your username."
                        : userData?.name,
                    onChanged: (val) => setState(() => _currentName = val),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    initialValue: userData?.bio,
                    decoration: textInputDecoration.copyWith(hintText: "Bio"),
                    validator: (val) =>
                        val!.isEmpty ? "Please enter your bio." : userData?.bio,
                    onChanged: (val) => setState(() => _currentBio = val),
                  ),
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
                      if (_formKey.currentState!.validate()) {
                        await DatabaseService(uid: user?.uid).updateUserData(
                            _currentName ?? userData!.name,
                            _currentBio ?? userData!.bio);
                      }
                      Navigator.pop(context);
                    },
                  ),
                ],
              ));
          // } else {
          //   return Loading();
          // }
        });
  }
}
