import 'package:flutter/material.dart';

Widget profilePicture(double width, double height, double size) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: Colors.pink,
        width: 2.0,
      ),
    ),
    child: ClipOval(
      child: Icon(Icons.person, size: size),
    ),
  );
}