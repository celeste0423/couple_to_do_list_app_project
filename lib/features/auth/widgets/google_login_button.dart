import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/helper/show_alert_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final AuthController authController = AuthController();

    Future<UserCredential> _signInWithGoogle() async {
      //구글 로그인 페이지 표시
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return showAlertDialog(context: context, message: '로그인에 실패했습니다');
      }

      //로그인 성공, 유저정보 가져오기
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      //파이어베이스 인증 정보 로그인
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await _auth.signInWithCredential(credential);
    }

    return GestureDetector(
      onTap: () async {
        UserCredential? userCredential = await _signInWithGoogle();
        if (userCredential == null) {
          showAlertDialog(context: context, message: '로그인 실패');
        } else {
          print('로그인 성공');
          authController.changeRegisterProgressIndex('userRegistration');
        }
      },
      child: Image.asset(
        'assets/images/google_login_btn.png',
      ),
    );
  }
}
