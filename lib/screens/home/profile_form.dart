import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gather_go/Models/ProfileOnScreen.dart';
import 'package:gather_go/screens/admin/adminNav.dart';
import 'package:gather_go/screens/home/editProfile.dart';
import 'package:gather_go/services/auth.dart';
import 'package:gather_go/services/database.dart';
import 'package:gather_go/shared/contants.dart';
import 'package:gather_go/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:gather_go/Models/NewUser.dart';
import 'package:gather_go/shared/build_appbar.dart';
import 'package:gather_go/Models/UesrInfo.dart';
import 'dart:io';
import 'package:gather_go/shared/profile_widget.dart';
import 'package:gather_go/screens/home/MyEvents.dart';

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
    final user = Provider.of<NewUser>(context);
    ProfileData? profileData;
    //final AuthService _auth = AuthService();
    return StreamBuilder<ProfileData>(
        stream: DatabaseService(uid: user.uid).profileData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            profileData = snapshot.data;
          }
          return Scaffold(
            appBar: buildAppBar(context),
            body: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                ProfileWidget(
                  imagePath:
                      "https://picsum.photos/200/300", //random image // profileData.imageUrl
                  isEdit: false,
                  onClicked: () async {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => EditProfilePage()));
                  },
                ),

                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     primary: Colors.purple[500],
                //     shadowColor: Colors.purple[800],

                //     shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(25)),

                //   ),
                //   child: Text(
                //     'Submit',
                //     style: TextStyle(
                //       fontSize: 20,
                //       fontWeight: FontWeight.w700,
                //     ),
                //   ),
                //   onPressed: () async {
                //     // dynamic create_profile =
                //     //     await DatabaseService(uid: user.uid).addProfileData(
                //     //         user.uid, "bio", "email", "asd", "imageUrl");
                //   },
                // ),
                const SizedBox(
                  height: 24,
                ),
                buildName(profileData),
                const SizedBox(
                  height: 30,
                ),
                buildAbout(profileData),
                const SizedBox(
                  height: 24,
                ),
                buildEvents(profileData)
              ],
            ),
            // final user = Provider.of<NewUser?>(
            //     context); //storing user (before we made snapshot method in database class
            // //then made userData class(in UserOnScreen file) then access user data snapshot here in form) tut.25
            // ProfileData? userData;
            // final AuthService _auth = AuthService();

            // return StreamBuilder<ProfileData>(
            //     stream: DatabaseService(uid: user?.uid).profileData,
            //     builder: (context, snapshot) {
            //       if (snapshot.hasData) {
            //         userData = snapshot.data;
            //       }

            //       return Form(
            //           key: _formKey,
            //           child: Column(
            //             children: <Widget>[
            //               Text(
            //                 "Edit Your Profile",
            //                 style: TextStyle(fontSize: 18),
            //               ),
            //               SizedBox(height: 20),
            //               TextFormField(
            //                 initialValue: userData?.name,
            //                 decoration:
            //                     textInputDecoration.copyWith(hintText: "Username"),
            //                 validator: (val) => val!.isEmpty
            //                     ? "Please enter your username."
            //                     : userData?.name,
            //                 onChanged: (val) => setState(() => _currentName = val),
            //               ),
            //               SizedBox(height: 20),
            //               TextFormField(
            //                 initialValue: userData?.bio,
            //                 decoration: textInputDecoration.copyWith(hintText: "Bio"),
            //                 validator: (val) =>
            //                     val!.isEmpty ? "Please enter your bio." : userData?.bio,
            //                 onChanged: (val) => setState(() => _currentBio = val),
            //               ),
            //               SizedBox(height: 20),
            //               ElevatedButton(
            //                 style: ButtonStyle(
            //                     backgroundColor:
            //                         MaterialStateProperty.all(Colors.purple[300]),
            //                     foregroundColor:
            //                         MaterialStateProperty.all(Colors.white)),
            //                 child: Text('Save changes'),
            //                 onPressed: () async {
            //                   //update db here using stream provider and database class
            //                   if (_formKey.currentState!.validate()) {
            //                     await DatabaseService(uid: user?.uid).updateProfileData(
            //                         _currentName ?? userData!.name,
            //                         _currentBio ?? userData!.bio);
            //                   }
            //                   //   Navigator.pop(context);
            //                 },
            //               ),
            //               TextButton.icon(
            //                 onPressed: () async {
            //                   await _auth.SignOut();
            //                 },
            //                 icon: Icon(Icons.logout_rounded),
            //                 label: Text("Logout"),
            //               )
            //             ],
            //           ));
            //       // } else {
            //       //   return Loading();
            //       // }
            //     });
          );
        });
  }

  Widget buildName(ProfileData? user) => Column(
        children: [
          Text(
            user?.name ?? 'Huda',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            user?.email ?? 'huda1@gmail.com',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ],
      );

  Widget buildAbout(ProfileData? user) => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          children: [
            Text(
              "About ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              user?.bio ??
                  'I\'m a senior software engineering student at king Saud University. Our SWE group is currently developing this app.',
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
            ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.purple[300]),
                  foregroundColor: MaterialStateProperty.all(Colors.white)),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout_outlined),
              label: Text('Log out'),
            ),
          ],
        ),
      );
  Widget buildEvents(ProfileData? user) => Container(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.purple[300]),
                      foregroundColor: MaterialStateProperty.all(Colors.white)),
                  child: Text(
                    'My Events',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => MyEvents()));
                  }),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.purple[300]),
                      foregroundColor: MaterialStateProperty.all(Colors.white)),
                  child: Text(
                    'Booked Events',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => MyEvents()));
                  }),
            )
          ],
        ),
      );
}

// class logout extends StatelessWidget {
//   const logout({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: ElevatedButton(
//         onPressed: () async {
//           await FirebaseAuth.instance.signOut();
//         },
//         child: Text('logout'),
//       ),
//     );
//   }
// }
