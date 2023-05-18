import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/material.dart';

class ShortHBar extends StatelessWidget {
  const ShortHBar({
    Key? key,
    this.height,
    this.width,
    this.color,
  }) : super(key: key);

  final double? height;
  final double? width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 5,
      width: width ?? 35,
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: color ?? CustomColors.lightGrey,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
