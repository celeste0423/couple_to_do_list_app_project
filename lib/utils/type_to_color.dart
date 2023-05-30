import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/material.dart';

class TypeToColor {
  static Color typeToColor(String? type) {
    switch (type) {
      case '1travel':
        return CustomColors.travel;
      case '2meal':
        return CustomColors.meal;
      case '3activity':
        return CustomColors.activity;
      case '4culture':
        return CustomColors.culture;
      case '5study':
        return CustomColors.study;
      case '6etc':
        return CustomColors.etc;

      default:
        return Colors.white;
    }
  }
}
