import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/helper/open_alert_dialog.dart';
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

        if (userCredential == null) {
          openAlertDialog(title: '로그인 실패');
        } else {
          print('(gog but) ${AuthController.to.user.value.nickname}');
          AuthController.loginType = 'google';
        }
        Get.back();
      },
      child: Stack(
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.black.withOpacity(0.2)),
            ),
            child: Center(
              child: Text(
                '구글로 로그인',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Positioned(
            left: 10,
            top: 10,
            child: Image.asset(
              'assets/icons/google.png',
              height: 30,
            ),
          ),
        ],
      ),
    );
  }
}
