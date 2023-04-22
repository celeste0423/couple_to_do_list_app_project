import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/material.dart';

Widget mainButton(
  String text,
  Function onPressed,
) {
  return SizedBox(
    height: 50,
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        backgroundColor: CustomColors.mainPink, // Background color
      ),
      onPressed: onPressed != null ? () => onPressed!() : null,
      child: Text(
        text,
        style: TextStyle(fontSize: 35, color: Colors.white),
      ),
    ),
  );
}
