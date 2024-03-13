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

Widget backButton() {
  return Container(
    width: 42,
    height: 42,
    decoration: const BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
    ),
    child: const ClipOval(
      child: Icon(Icons.arrow_back, size: 28),
    ),
  );
}