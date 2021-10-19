import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              title: Text(
                 "Reset Password",
                style: TextStyle(
                  fontFamily: 'Comfortaa',
                  fontSize: 27,
                  color: Colors.orangeAccent),
                textAlign: TextAlign.center,
              ),
            ),
            body: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                height: 800,
                child: Form(
                    key: _formKey, //---------------------------------------
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration:
                              textInputDecoration.copyWith(hintText: "Email"),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter your email";
                            }
                            if (!RegExp(
                                    "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
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
                          child: Text("Send password reset email",
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                loading = true;
                              });
                                  await _auth.sendPasswordResetEmail(email: email);
                                  //_auth.confirmPasswordReset(code: code, newPassword: newPassword)
                                  Fluttertoast.showToast(msg: 'Check your email, reset email sent');
                                  emailSent= true;
                                  Navigator.of(context).pop();
                            }
                            if (!emailSent)
                            setState(() {
                                  error =
                                      'The email is not registered'; //user
                                  loading = false;
                                });
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.amber),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              padding: 
                              MaterialStateProperty.all(EdgeInsets.only(top: 10,bottom: 10, left: 100, right: 100)),),
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        Text(error, style: TextStyle(color: Colors.red))
                      ],
                    )),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image:  AssetImage('images/Picture1.png'), 
                        fit: BoxFit.contain,
                        alignment: Alignment.bottomCenter,)
                      ),
                    ),
          );
  }
}
