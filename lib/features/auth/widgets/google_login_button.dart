import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/helper/show_alert_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        UserCredential? userCredential =
            await AuthController.to.signInWithGoogle();

        if (null == userCredential) {
          openAlertDialog(title: '로그인 실패');
        } else {
          print('(gog but) ${AuthController.to.user.value.nickname}');
          AuthController.loginType = 'google';
        }
        Get.back();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Image.asset(
          'assets/images/google_login_btn_res.png',
          height: 70,
        ),
      ),
    );
  }
}
