import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  String text;
  Color? color;

  TitleText({
    Key? key,
    required this.text,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color ?? CustomColors.blackText,
        fontSize: 25,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
