import 'package:flutter/material.dart';
import 'package:gather_go/services/auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _fromkey = GlobalKey<FormState>();


  String username='';
  String password='';
  String error='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[100],
      appBar: AppBar(
        backgroundColor: Colors.amber[100],
        elevation: 0.0,
        title: Text(
          "Sign in to Gather Go",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          key: _fromkey,
          child: Column(
            children: [
              TextFormField(
                validator: (value) => value!.isEmpty? 'Enter your username': null,
                onChanged: (value) {
                  setState(() => username=value);
                },
              ),
              TextFormField(
                obscureText: true,
                validator: (value) => value!.isEmpty? 'Enter your passord': null,
                onChanged: (value) {
                  setState(() => password = value);
                },
              ),
              ElevatedButton(
                child: Text("Login"),
                onPressed: () async {
                // dynamic result = await _auth.signInAnon();
                // if (result == null) {
                // print("signing in error");
                // } else {
                //   print("signed in successfully");
                //   print(result);
                // }
                if (_fromkey.currentState!.validate()){
                  dynamic result = await _auth.SignInWithUsernameAndPassword(username, password);
                  if (result == null)
                    setState(() => error = 'Username or password is incorrect');
                  }
                },
              ),
              Text('Don’t have an account?'),
              Text('Register now'),
              SizedBox(height: 12.0,),
              Text(
                error,
              )
            ],)
          )
      ),
    );
  }
}
