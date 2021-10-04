import 'package:flutter/material.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  //const GradientAppBAr({ Key? key }) : super(key: key);
  @override
  Size get preferredSize => const Size.fromHeight(100);

  final double _height = 50.0;
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
              colors: <Color>[Colors.purple[300]!, Colors.purple[300]!])),
      child: Text(
        "Gather Go",
        style: TextStyle(
          color: Colors.white,
          letterSpacing: 7,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
