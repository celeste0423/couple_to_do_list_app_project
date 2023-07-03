import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/helper/show_alert_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class KakaoLoginButton extends StatelessWidget {
  final AuthController authController = AuthController();

  String? userid;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        //커스텀 토큰 받아옴
        String? customToken = await AuthController.to.signInWithKakao();
        //파이어베이스 auth 등록
        if (customToken == null || customToken == '') {
          openAlertDialog(title: '로그인 실패');
        } else {
          AuthController.loginType = 'kakao';
          print('(kak btn) 로그인 타입 ${AuthController.loginType}');
          await FirebaseAuth.instance.signInWithCustomToken(customToken);
        }
      },
      child: Image.asset(
        'assets/images/kakao_login_medium_wide.png',
        height: 80,
      ),
    );
  }
}
