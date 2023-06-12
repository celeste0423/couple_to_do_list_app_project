import 'package:flutter/material.dart';

class PngIcon extends StatelessWidget {
  String iconName;
  Color? iconColor;
  double? iconSize;

  PngIcon({
    Key? key,
    required this.iconName,
    this.iconColor,
    this.iconSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/icons/$iconName.png',
      color: iconColor ?? Colors.black.withOpacity(0.5),
      colorBlendMode: BlendMode.modulate,
      width: iconSize ?? 35,
      height: iconSize ?? 35,
    );
  }
}
