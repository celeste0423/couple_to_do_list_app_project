import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/material.dart';

Widget auxiliaryButton(String text, Function()? onPressed,[double? x]){
  return SizedBox(
    height: 50,
    width: x ?? double.infinity,
    child: OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        side: BorderSide(
          width: 2,
          color: CustomColors.lightPink
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        //elevation: 5,
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(fontSize: 35, color: CustomColors.lightPink),
      ),
    ),
  );
}