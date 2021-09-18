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

//textfield state
  String username = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading() //
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              title: Text(
                "Signup to Gather Go",
                style: TextStyle(color: Colors.black),
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
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration:
                              textInputDecoration.copyWith(hintText: "Email"),
                          validator: (value) =>
                              value!.isEmpty ? 'Enter your email' : null,
                          onChanged: (value) {
                            setState(() => username = value);
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
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
                        ElevatedButton(
                          child: Text("Register"),
                          onPressed: () async {
                            if (_fromkey.currentState!.validate()) {
                              setState(() {
                                loading = true;
                              });
                              //firebase register here and in auth.dart
                              dynamic result =
                                  await _auth.signUpWithUsernameAndPassword(
                                      username, password);
                              if (result == null)
                                setState(() {
                                  error = 'Email or password is incorrect';
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
