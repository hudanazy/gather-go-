import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gather_go/screens/myAppBar.dart';
import 'package:gather_go/services/auth.dart';
import 'package:gather_go/shared/contants.dart';
import 'package:gather_go/shared/loading.dart';

class resetPassword extends StatefulWidget {
  @override
  _resetPasswordState createState() => _resetPasswordState();
}

class _resetPasswordState extends State<resetPassword> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;
  bool emailSent = false;
//textfield state
  String email = '';
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            appBar: SecondaryAppBar(
              title: "Reset Password",
            ),
            // AppBar(
            //   leading: IconButton(
            //     color: Colors.amber,
            //     icon: new Icon(Icons.arrow_back_ios),
            //     onPressed: () {
            //       Navigator.pop(context);
            //     },
            //   ),
            //   backgroundColor: Colors.white,
            //   elevation: 0.0,
            //   title: Text(
            //      "Reset Password",
            //     style: TextStyle(
            //       fontFamily: 'Comfortaa',
            //       fontSize: 27,
            //       color: Colors.amber),

            //     textAlign: TextAlign.center,
            //   ),
            // ),
            body: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 150, horizontal: 50),
              height: 800,
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        autofocus: true,
                        decoration:
                            textInputDecoration.copyWith(hintText: "Email"),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter your email";
                          }
                          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                              .hasMatch(value.trim())) {
                            return "Enter valid email ";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() => email = value.trim());
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        child: Text("Submit",
                            style: TextStyle(
                                fontFamily: 'Comfortaa',
                                fontWeight: FontWeight.bold)),
                        onPressed: () async {
                          setState(() {
                            error = '';
                          });
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });
                            await _auth
                                .sendPasswordResetEmail(email: email)
                                .then((value) {
                              if (loading)
                                setState(() {
                                  loading = false;
                                });
                              Navigator.of(context).pop();
                              Fluttertoast.showToast(
                                  msg:
                                      'Password reset link has been sent to $email');
                            }).catchError((onError) {
                              if (onError
                                  .toString()
                                  .contains("An internal error has occurred")) {
                                setState(() {
                                  error = onError;
                                  loading = false;
                                });
                              } else {
                                setState(() {
                                  error = 'The email is not registered';
                                  loading = false;
                                });
                              }
                            });
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.orange[300]),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 50)),
                        ),
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      Text(error, style: TextStyle(color: Colors.red))
                    ],
                  )),
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('images/Picture1.png'),
                fit: BoxFit.contain,
                alignment: Alignment.bottomCenter,
              )),
            ),
          );
  }
}
