import 'package:flutter/material.dart';
import 'package:gather_go/screens/authenticate/sign_in.dart';
import 'package:gather_go/services/auth.dart';
import 'package:gather_go/shared/loading.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String username = '';
  String confirmPass = '';
  // final __passwordControl = TextEditingController();
  // final __passwordconfirm = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.amber[100],
            appBar: AppBar(
              backgroundColor: Colors.amber[100],
              elevation: 0.0,
              title: Text(
                "Register to Gather Go",
                style: TextStyle(color: Colors.black),
              ),
            ),
            body: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Username',
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Enter your username' : null,
                          onChanged: (value) {
                            setState(() => username = value);
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'email',
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Enter your email' : null,
                          onChanged: (value) {
                            setState(() => email = value);
                          }, //email
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: ' password'),
                          obscureText: true,
                          validator: (value) => value!.length < 6
                              ? 'Enter your passord 6+ chars long'
                              : null,
                          onChanged: (value) {
                            setState(() => password = value);
                          },
                        ),
                        TextFormField(
                          //controller: __passwordconfirm,
                          decoration:
                              InputDecoration(labelText: 'Confirm password'),
                          obscureText: true,
                          validator: (value) =>
                              value != password ? ' Confirm password ' : (null),
                          onChanged: (value) {
                            setState(() => password = value);
                          },
                        ),
                        //confirm pass
                        ElevatedButton(
                          child: Text("Register"),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                // to show loading icon
                                loading = true;
                              });
                              dynamic result = await _auth
                                  .registerWithEmailAndUsernameAndPassword(
                                      email, password);
                              if (result == null)
                                setState(() {
                                  error = 'pleas supply a valid email  ';
                                  loading = true;
                                });
                            }
                          },
                        ),
                        Text('Alraedy have an account?'),
                        ElevatedButton(
                          child: Text('Login now'),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SignIn())); //https://flutter.dev/docs/cookbook/navigation/navigation-basics
                          },
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        Text(
                          error,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 18.0,
                          ),
                        )
                      ],
                    ))),
          );
  }
}
