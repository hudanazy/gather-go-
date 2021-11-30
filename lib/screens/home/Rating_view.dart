import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gather_go/screens/home/MyEventsDetails.dart';

class RatingView extends StatefulWidget {
  RatingView({Key? key}) : super(key: key);

  @override
  _RatingViewState createState() => _RatingViewState();
}

class _RatingViewState extends State<RatingView> {
  var _ratingPageController = PageController();
  var StarPostion = 200.0;
  var Rating = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Container(
            height: min(300, MediaQuery.of(context).size.height * 0.5),
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
          Positioned(
              right: -22,
              // top: 10,
              child: MaterialButton(
                  onPressed: () {
                    //rout to
                    // _eventDetails();
                  },
                  child: Text(
                    "Skip >",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    // style:TextStyle(fontWeight:),
                    // style: TextStyle(),
                    textAlign: TextAlign.right,
                  ))),
          //SizedBox(width: 20),
          //    Positioned(
          //  child:
          AnimatedPositioned(
            top: StarPostion,
            left: 0,
            right: 0,
            // bottom: 10,
            // top: 15,

            child: Row(
              children: List.generate(
                5,
                (index) => IconButton(
                  icon: index < Rating
                      ? Icon(Icons.star, size: 30)
                      : Icon(Icons.star_border, size: 30),
                  color: Colors.yellow,
                  onPressed: () {
                    setState(() {
                      StarPostion = 20;
                      Rating = index + 1;
                    });
                  },
                ),
              ),
            ),
            duration: Duration(milliseconds: 300),
          )
        ],
      ),
    );
  }

  _Rating() {
    return Container();
  }

  _ThanksNots() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "  We would love to get your feedback about this event :)  ",
          style: TextStyle(fontSize: 20, color: Colors.deepPurple),
          textAlign: TextAlign.center,
        ),
        // Text('WE\'d loved to get your feedback'),
      ],
    );
  }
}
