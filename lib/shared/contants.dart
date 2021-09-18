import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
    fillColor: Colors.white54,
    // border: OutlineInputBorder(
    //   borderRadius: const BorderRadius.all(const Radius.circular(15)),
    // ),
    filled: true,
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.amberAccent, width: 1),
        borderRadius: BorderRadius.all(const Radius.circular(15))),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.amber, width: 2),
        borderRadius: BorderRadius.all(const Radius.circular(15))));
