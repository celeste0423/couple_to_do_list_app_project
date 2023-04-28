import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final Icon? icon;
  final Color? backgroundColor;
  final double? size;
  final Offset? shadowOffset;
  final double? shadowBlurRadius;

  const CustomIconButton({
    Key? key,
    required this.onTap,
    this.icon,
    this.backgroundColor,
    this.size,
    this.shadowOffset,
    this.shadowBlurRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size ?? 50,
        height: size ?? 50,
        decoration: BoxDecoration(
          color: backgroundColor ?? CustomColors.mainPink,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: shadowBlurRadius ?? 10,
              offset: shadowOffset ?? Offset(15, 0), // Offset(수평, 수직)
            ),
          ],
        ),
        child: icon ??
            Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
            ),
      ),
    );
  }
}
