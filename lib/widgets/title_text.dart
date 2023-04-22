import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/material.dart';

Widget titleText(String text) {
  return Text(
    text,
    style: TextStyle(
      color: CustomColors.darkGrey,
      fontSize: 50,
    ),
  );
}
