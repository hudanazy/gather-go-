import 'package:flutter/material.dart';
import 'package:gather_go/screens/authenticate/sign_in.dart';
import 'package:gather_go/services/auth.dart';
import 'package:gather_go/shared/contants.dart';
import 'package:gather_go/shared/loading.dart';

class Register extends StatefulWidget {
  final VoidCallback toggleView;
  Register(this.toggleView);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();

  final _fromkey = GlobalKey<FormState>();
  bool loading = false;
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
//textfield state
  String username = '';
  String password = '';
  String error = '';
  String Confirm = '';
  String email = '';
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading() //
        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              title: Text(
                "Signup to Gather Go",
                style: TextStyle(color: Colors.orangeAccent),
                textAlign: TextAlign.center,
              ),
            ),
            // actions: <Widget>[
            //   TextButton.icon(
            //       onPressed: () {},
            //       icon: Icon(Icons.person),
            //       label: Text("Register"))
            // ]),
            body: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: Form(
                    key: _fromkey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: "Username"),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter your Username';
                            }
                          },
                          onChanged: (value) {
                            setState(() => email = value);
                          },
                        ),
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
                                .hasMatch(value)) {
                              return "Enter valid email ";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() => username = value);
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _pass,
                          decoration: textInputDecoration.copyWith(
                              hintText: "Password"),
                          obscureText: true,
                          validator: (value) => value!.length < 8
                              ? 'Enter a password 8+ chars long.'
                              : null,
                          onChanged: (value) {
                            setState(() => password = value);
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _confirmPass,
                          decoration: textInputDecoration.copyWith(
                              hintText: "Confirm Password "),
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter Confirm Password';
                            }
                            if (value != _pass.text) {
                              return 'password Not Match';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() => password = value);
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          child: Text("SignUp"),
                          onPressed: () async {
                            if (_fromkey.currentState!.validate()) {
                              setState(() {
                                loading = true;
                              });
                              //firebase register here and in auth.dart
                              dynamic result =
                                  await _auth.signUpWithUsernameAndPassword(
                                      username, email, password, Confirm);
                              if (result == null)
                                setState(() {
                                  error =
                                      'The email and username are registered';
                                  loading = false;
                                });
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.amber),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white)),
                        ),
                        Text('Have an account?'),
                        ElevatedButton(
                          child: Text('Login now'),
                          onPressed: () {
                            widget.toggleView();
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             Register())); //https://flutter.dev/docs/cookbook/navigation/navigation-basics
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.purple[300]),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white)),
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        Text(error, style: TextStyle(color: Colors.red))
                      ],
                    ))),
          );

    //Text('Alraedy have an account?'),
    // body:
    //         ElevatedButton(
    //           child: Text('Login now'),
    //           onPressed: () {
    //             Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn())); //https://flutter.dev/docs/cookbook/navigation/navigation-basics
    //           },),
    // );
  }
}
