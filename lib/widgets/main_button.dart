import 'package:flutter/material.dart';

Widget mainButton(
  String text,
  Function()? onPressed,
    [double? x, Color? color]
) {
  return SizedBox(
    height: 50,
    width: x ?? double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color, // Background color
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(fontSize: 35, color: Colors.white),
      ),
    ),
  );
}
