import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/helper/show_alert_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppleLoginButton extends StatelessWidget {
  final AuthController authController = AuthController();

  String? userid;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        //Todo: 애플 로그인 구현
        UserCredential? userCredential =
            await AuthController.to.signInWithApple();
        if (userCredential == null) {
          openAlertDialog(title: '로그인 실패');
        } else {
          print(
              'apple login 성공: nickname = ${AuthController.to.user.value.nickname}');
          //로그인 타입 설정
          AuthController.loginType = 'apple';
        }
      },
      child: Stack(
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xFF000000),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(),
            ),
            child: Center(
              child: Text(
                'Apple로 로그인',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            left: 5,
            top: 5,
            child: Image.asset(
              'assets/icons/apple.png',
              height: 40,
            ),
          ),
        ],
      ),
    );
  }
}
