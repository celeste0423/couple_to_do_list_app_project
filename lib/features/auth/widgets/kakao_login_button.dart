import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/helper/open_alert_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class KakaoLoginButton extends StatelessWidget {

  String? userid;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        //커스텀 토큰 받아옴
        String? customToken = await AuthController.to.signInWithKakao();
        //파이어베이스 auth 등록
        if (customToken == null ||
            customToken == '' ||
            customToken == 'Internal Server Error') {
          openAlertDialog(title: '로그인 실패');
        } else {
          AuthController.loginType = 'kakao';
          print('(kak btn) 로그인 타입 ${AuthController.loginType}');
          print(customToken);
          await FirebaseAuth.instance.signInWithCustomToken(customToken);
        }
      },
      child: Stack(
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xFFFBDB3F),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                '카카오로 로그인',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 15,
                  color: Color(0xFF3A2929),
                ),
              ),
            ),
          ),
          Positioned(
            left: 5,
            top: 5,
            child: Image.asset(
              'assets/icons/kakaos.png',
              height: 40,
            ),
          ),
        ],
      ),
    );
  }
}
