// import 'package:flutter/material.dart';

// void main() => runApp(MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text("Event Requests"),
//           centerTitle: true,
//         ),
//         body: Center(child: Text("Book Club")),
//         floatingActionButton: FloatingActionButton(
//           onPressed: null,
//           child: Text("Approve"),
//         ),
//       ),
//     ));

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

/// This is the main application widget.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Event requests',
      style: optionStyle,
    ),
    Text(
      'Logging out',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Log Out',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class Login extends State<MyStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Image.asset('images/Pisture1.png'),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.amber[600]),
              child: Text('Login'),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}



/* 
//class SignUp extends State<MyStatefulWidget> {
 // @override
 // Widget build(BuildContext context) {
  //  return Scaffold(
   //   body:Column(children:<Widget >[ Container(child:Stack(children: [Container(padding: EdgeInsets.fromLTRB(10.0, 90, 0.0, 0.0),
     child: Text('Sign Up',style: TextStyle(fontSize: 50,color:Colors.amber[600]),//textS 
       ),
       )
        ],
       )
       )
       ],
       ),
       
      body: Center(
        child: Column(

          children:<Widget> [
            Image.asset('images/Pisture1.png'),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.amber[600]
              ),
              
              child: Text('Sign Up'),
              onPressed: () {},
              
            ),
          ],
        ),
      ),
    );
  }
}  */ 