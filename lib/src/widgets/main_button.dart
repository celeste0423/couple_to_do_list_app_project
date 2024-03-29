import 'package:couple_to_do_list_app/src/utils/custom_color.dart';
import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  String buttonText;
  VoidCallback onTap;
  Color? buttonColor;
  Color? textColor;
  double? width;
  double? height;

  MainButton({
    Key? key,
    required this.buttonText,
    required this.onTap,
    this.buttonColor,
    this.textColor,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height ?? 45,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: buttonColor ?? CustomColors.mainPink,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: Offset(0, 0),
                blurRadius: 5,
              ),
            ]),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
