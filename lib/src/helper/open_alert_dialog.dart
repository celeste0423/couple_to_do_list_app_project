import 'package:couple_to_do_list_app/src/utils/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

openAlertDialog({
  required String title,
  String? content,
  String? btnText,
  String? secondButtonText,
  VoidCallback? mainfunction,
  VoidCallback? secondfunction,
}) {
  return Get.dialog(
    AlertDialog(
      titlePadding:
          const EdgeInsets.only(top: 30, left: 30, right: 20, bottom: 10),
      contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      title: Text(
        title,
        style: TextStyle(
          color: CustomColors.blackText,
          fontSize: 15,
        ),
      ),
      content: content == null
          ? null
          : Text(
              content,
              style: TextStyle(
                color: CustomColors.darkGrey,
                fontSize: 13,
              ),
            ),
      actions: [
        Visibility(
          visible: secondButtonText != null,
          child: TextButton(
            onPressed: () {
              if (secondfunction != null) {
                secondfunction();
              } else {
                Get.back();
              }
            },
            child: Text(
              secondButtonText ?? '',
              style: const TextStyle(
                fontSize: 13,
                color: CustomColors.greyText,
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            if (mainfunction != null) {
              mainfunction();
            } else {
              Get.back();
            }
          },
          child: Text(
            btnText ?? "확인",
            style: TextStyle(
              fontSize: 13,
              color: CustomColors.mainPink,
            ),
          ),
        ),
      ],
    ),
  );
}

Future<bool> openBoolAlertDialog({
  required String title,
  String? content,
  String? btnText,
  String? secondButtonText,
}) async {
  bool mainButtonClicked = false;

  await Get.dialog(
    WillPopScope(
      onWillPop: () async {
        mainButtonClicked = false;
        return true; // Return true to allow dialog to be dismissed when the back button is pressed
      },
      child: AlertDialog(
        title: Text(
          title,
          style: TextStyle(
            color: CustomColors.blackText,
            fontSize: 15,
          ),
        ),
        content: content == null
            ? null
            : Text(
                content,
                style: TextStyle(
                  color: CustomColors.darkGrey,
                  fontSize: 13,
                ),
              ),
        contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        actions: [
          secondButtonText != null
              ? TextButton(
                  onPressed: () {
                    mainButtonClicked =
                        false; // Set to false when secondary button is pressed
                    Get.back(result: false);
                  },
                  child: Text(
                    secondButtonText,
                    style: TextStyle(
                      fontSize: 13,
                      color: CustomColors.greyText,
                    ),
                  ),
                )
              : Container(),
          TextButton(
            onPressed: () {
              mainButtonClicked =
                  true; // Set to true when main button is pressed
              Get.back(result: true);
            },
            child: Text(
              btnText ?? "확인",
              style: TextStyle(
                fontSize: 13,
                color: CustomColors.mainPink,
              ),
            ),
          ),
        ],
      ),
    ),
  );

  return mainButtonClicked;
}
