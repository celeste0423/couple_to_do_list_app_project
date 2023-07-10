import 'package:couple_to_do_list_app/utils/custom_color.dart';
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
        height: height ?? 50,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: buttonColor ?? CustomColors.mainPink,
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}

// Widget mainButton(
//   String text,
//   Function()? onPressed,
//     [double? x, Color? color]
// ) {
//   return SizedBox(
//     height: 50,
//     width: x ?? double.infinity,
//     child: ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: color, // Background color
//       ),
//       onPressed: onPressed,
//       child: Text(
//         text,
//         style: TextStyle(fontSize: 35, color: Colors.white),
//       ),
//     ),
//   );
// }
