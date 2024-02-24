import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:story_app/common/style.dart';

void showSnackBar(BuildContext context, String msg) {
  final message = capitalizeFirstLetter(msg);
  final snackBar = SnackBar(
    content: Text(message),
    duration: const Duration(seconds: 3),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

String capitalizeFirstLetter(String text) {
  return text.substring(0, 1).toUpperCase() + text.substring(1).toLowerCase();
}

Text primaryText(String txt) {
  return Text(txt, style: TextStyle(color: lightTheme.primary),);
}

InputDecoration formFieldDecor(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: TextStyle(color: lightTheme.primary),
    filled: true,
    fillColor: lightTheme.primaryContainer,
    border: InputBorder.none,
    contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
  );
}

String convertDateTime(DateTime time) {
  return DateFormat.yMMMMd().format(time);
}