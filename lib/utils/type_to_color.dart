import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/material.dart';

class TypeToColor {
  static Color typeToColor(String? type) {
    switch (type) {
      case 'travel':
        return CustomColors.travel;
      case 'meal':
        return CustomColors.meal;
      case 'activity':
        return CustomColors.activity;
      case 'culture':
        return CustomColors.culture;
      case 'study':
        return CustomColors.study;
      case 'etc':
        return CustomColors.etc;

      default:
        return Colors.white;
    }
  }
}
