import 'package:flutter/material.dart';
import 'package:gather_go/screens/admin/eventdetailsLogo.dart';

import 'package:gather_go/services/auth.dart';
import 'package:gather_go/shared/contants.dart';
import 'package:gather_go/shared/loading.dart';
//import 'package:gather_go/screens/admin/eventDetails.dart';
import 'package:gather_go/screens/authenticate/resetPassword.dart';

//import 'package:gather_go/screens/admin/eventdetailsLogo.dart';

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
                "Login",
                style: TextStyle(
                    fontFamily: 'Comfortaa',
                    fontSize: 27,
                    color: Colors.amber[600]),
                textAlign: TextAlign.center,
              ),
            ),
            body: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              height: 800,
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
                          setState(() => username = value.trim());
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: "Password"),
                        obscureText: true,
                        validator: (value) =>
                            value!.isEmpty ? 'Enter your password' : null,
                        onChanged: (value) {
                          setState(() => password = value.trim());
                        },
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => resetPassword())),
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                              color: Colors.purple[300], fontSize: 16),
                        ),
                      ),
                      // SizedBox(
                      //   height: 12,
                      // ),
                      Text(error, style: TextStyle(color: Colors.red)),
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
                                error = 'Email or password is wrong.';
                                loading = false;
                              });
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.amber),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 50)),
                        ),
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
