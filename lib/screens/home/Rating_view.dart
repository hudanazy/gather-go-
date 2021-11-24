import 'dart:math';

import 'package:flutter/material.dart';

class RatingView extends StatefulWidget {
  RatingView({Key? key}) : super(key: key);

  @override
  _RatingViewState createState() => _RatingViewState();
}

class _RatingViewState extends State<RatingView> {
  var _ratingPageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Container(
            height: max(300, MediaQuery.of(context).size.height * 0.3),
            child: PageView(
              controller: _ratingPageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _ThanksNots(),
                _Rating(),
              ],
            ),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.amber,
                child: MaterialButton(
                  onPressed: () {},
                  child: Text('Done'),
                  textColor: Colors.white,
                ),
              )),
          AnimatedPositioned(
            child: Row(
              children: List.generate(
                5,
                (index) => IconButton(
                  icon: Icon(Icons.star, size: 32),
                  color: Colors.yellow,
                  onPressed: () {},
                ),
              ),
            ),
            duration: Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  _ThanksNots() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "We would love to get your feedback",
          style: TextStyle(fontSize: 24, color: Colors.deepPurple),
          textAlign: TextAlign.center,
        ),
        // Text('WE\'d loved to get your feedback'),
      ],
    );
  }

  _Rating() {
    return Container();
  }
}
