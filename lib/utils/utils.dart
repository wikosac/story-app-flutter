import 'package:flutter/material.dart';
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
  return Text(txt, style: TextStyle(color: lightColorScheme.primary),);
}

InputDecoration formFieldDecor(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: TextStyle(color: lightColorScheme.primary),
    filled: true,
    fillColor: lightColorScheme.primaryContainer,
    border: InputBorder.none,
    contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
  );
}