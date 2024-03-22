import 'package:couple_to_do_list_app/src/utils/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget RegistrationStage(int n) {
  return SizedBox(
    height: 40,
    child: Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: LinearProgressIndicator(
            color: Colors.white,
            backgroundColor: Colors.white.withOpacity(0.5),
            value: n == 1 ? 1 / 3 : 2 / 3,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 3,
                ),
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '1',
                  style: TextStyle(
                    color: CustomColors.grey,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            SizedBox(width: (Get.width - 40 * 2) / 3),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 3,
                ),
                color: n >= 2 ? Colors.white : CustomColors.mainPink,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '2',
                  style: TextStyle(
                    color: n >= 2 ? CustomColors.grey : Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            // SizedBox(
            //   width: 45,
            // ),
            // Container(
            //   width: 40,
            //   height: 40,
            //   decoration: BoxDecoration(
            //     border: Border.all(
            //       color: Colors.white.withOpacity(0.5),
            //       width: 3,
            //     ),
            //     color: n >= 3 ? Colors.white : CustomColors.mainPink,
            //     shape: BoxShape.circle,
            //   ),
            //   child: Center(
            //     child: Text(
            //       '3',
            //       style: TextStyle(
            //         color: n >= 3 ? CustomColors.grey : Colors.white,
            //         fontSize: 20,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ],
    ),
  );
}
