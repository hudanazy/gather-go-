import 'package:flutter/material.dart';
//import 'package:gather_go/screens/authenticate/register.dart';
import 'package:gather_go/services/auth.dart';
import 'package:gather_go/shared/contants.dart';
import 'package:gather_go/shared/loading.dart';
import 'package:gather_go/screens/admin/eventDetails.dart';

class SignIn extends StatefulWidget {
  // const SignIn({Key? key}) : super(key: key);

  final VoidCallback toggleView;
  SignIn(this.toggleView);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              title: Text(
                "Login to Gather Go",
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
            body: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: Form(
                    key: _fromkey,
                    child: Column(
                      children: [
                        ArcBannerImage(),
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
                          validator: (value) =>
                              value!.isEmpty ? 'Enter your password' : null,
                          onChanged: (value) {
                            setState(() => password = value);
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          child: Text("Login"),
                          onPressed: () async {
                            if (_fromkey.currentState!.validate()) {
                              setState(() {
                                loading = true;
                              });
                              //firebase login here and in auth.dart
                              dynamic result =
                                  await _auth.signInWithUsernameAndPassword(
                                      username, password);
                              if (result == null)
                                setState(() {
                                  error =
                                      'Could not sign in with those credentials.';
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
                        Text('Don’t have an account?'),
                        ElevatedButton(
                          child: Text('Register now'),
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
  }
}
