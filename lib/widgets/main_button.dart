import 'package:flutter/material.dart';

Widget mainButton(
  String text,
  Function onPressed,
) {
  return SizedBox(
    height: 50,
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onPressed != null ? () => onPressed!() : null,
      child: Text(
        text,
        style: TextStyle(fontSize: 35, color: Colors.white),
      ),
    ),
  );
}
