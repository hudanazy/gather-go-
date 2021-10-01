import 'package:flutter/material.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  //const GradientAppBAr({ Key? key }) : super(key: key);
  @override
  Size get preferredSize => const Size.fromHeight(100);

  final double _height = 100.0;
  // String title;
  // Color gradientBegin, gradientEnd;

  // GradientAppBar(this.title, this.gradientBegin, this.gradientEnd);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: <Color>[Colors.amber, Colors.purpleAccent])),
      child: Text(
        "Gather Go",
        style: TextStyle(
          color: Colors.white,
          letterSpacing: 10,
          fontSize: 30,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
