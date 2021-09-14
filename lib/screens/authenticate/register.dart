import 'package:flutter/material.dart';
import 'package:gather_go/screens/authenticate/sign_in.dart';
import 'package:gather_go/services/auth.dart';



class Register extends StatefulWidget {
  const Register({ Key? key }) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      

      //Text('Alraedy have an account?'),
      body: 
              ElevatedButton(
                child: Text('Login now'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn())); //https://flutter.dev/docs/cookbook/navigation/navigation-basics
                },),
    );
  }
}