import 'package:flutter/material.dart';
//import 'package:gather_go/screens/authenticate/sign_in.dart';
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
  String error = '';
  bool loading = false;

  final _fromkey = GlobalKey<FormState>();
  // bool loading = false;
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
//textfield state
  String name = '';
  String password = '';
  //String error = '';
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
                //"Signup to Gather Go",
                //style: TextStyle(color: Colors.orangeAccent),
                 "Register",
                style: TextStyle(
                  fontFamily: 'Comfortaa',
                  fontSize: 27,
                  color: Colors.orangeAccent),
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
                height: 800,
                child: Form(
                    key: _fromkey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: "Name"),
                          /* validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter your Username';
                            }
                          }, */

                          validator: (value) {
                            if (value!.trim().length < 2 || value.trim().isEmpty) {
                              return "Name is too short";
                            }
                            if (value.trim().length > 12) {
                              return "Name is too long";
                            }
                          },
                          onChanged: (value) {
                            setState(() => name = value.trim());
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
                        TextFormField(
                          controller: _pass,
                          decoration: textInputDecoration.copyWith(
                              hintText: "Password"),
                          obscureText: true,
                          validator: (value) => value!.trim().length < 8
                              ? 'Enter a password 8+ chars long.'
                              : null,
                          onChanged: (value) {
                            setState(() => password = value.trim());
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
                            if (value.trim() != _pass.text.trim()) {
                              return 'Password does not match';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() => password = value.trim());
                          },
                        ),
                        SizedBox(
                          height: 30,
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
                                      name, email, password, Confirm);

                              if (result == null)
                                setState(() {
                                  error =
                                      'The email is already registered'; //user
                                  loading = false;
                                });
                            }
                            /* dynamic resultuser =
                                await _auth.UsernameCheck(username);
                                if(!resultuser){
                                  //username exists

                                }
                                else if(_fromkey.currentState!.validate()){
                                      //save
                                } */
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.amber),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              padding: 
                              MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 10, horizontal: 115)),),
                        ),
                        Text('Already have an account?'),
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
                    )),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image:  AssetImage('images/Picture1.png'), 
                        fit: BoxFit.contain,
                        alignment: Alignment.bottomCenter,)
                      ),
                    ),
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
