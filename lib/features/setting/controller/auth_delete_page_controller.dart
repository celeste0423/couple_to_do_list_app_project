import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/helper/show_alert_dialog.dart';
import 'package:couple_to_do_list_app/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthDeletePageController extends GetxController {
  ScrollController pageScrollController = ScrollController();
  Rx<String> surveyResult = '자주 사용하지 않아요'.obs;
  TextEditingController feedbackController = TextEditingController();
  Rx<bool> isFeedback = false.obs;

  void authDeletion() async {
    _uploadFeedback();
    //uid 임시저장
    String? uid = AuthController.to.user.value.uid;

    //auth 삭제 전 재인증
    openAlertDialog(
        title: '삭제',
        content: '원활한 삭제를 위해 계정 인증 부탁드립니다.',
        function: () async {
          String loginType = await UserRepository.getLoginType();
          if (loginType == 'google') {
            final GoogleSignIn googleSignIn = GoogleSignIn();
            //구글 로그인 페이지 표시
            final GoogleSignInAccount? googleSignInAccount =
                await googleSignIn.signIn();
            GoogleSignInAuthentication googleAuth =
                await googleSignInAccount!.authentication;
            AuthCredential authCredential = GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken,
              idToken: googleAuth.idToken,
            );
            await FirebaseAuth.instance.currentUser
                ?.reauthenticateWithCredential(authCredential);
          } else if (loginType == 'kakao') {
            //커스텀 토큰 받아옴
            String? customToken = await AuthController.to.signInWithKakao();
            //파이어베이스 auth 등록
            if (customToken == null || customToken == '') {
              openAlertDialog(title: '로그인 실패');
            } else {
             // AuthController.loginType = 'kakao';
              print('(kak btn) 로그인 타입 ${AuthController.loginType}');
              await FirebaseAuth.instance.signInWithCustomToken(customToken);
            }
          } else if (loginType == 'apple') {
            UserCredential? userCredential = await AuthController.to.signInWithApple();
            if (userCredential == null) {
              openAlertDialog(title: '로그인 실패');
            } else {
              print(
                  'apple login 성공: nickname = ${AuthController.to.user.value.nickname}');
              //로그인 타입 설정
             // AuthController.loginType = 'apple';
            }
          }
        });
    //auth에서 삭제
    FirebaseAuth.instance.currentUser!.delete();
    //유저 파이어스토어 삭제
    FirebaseFirestore.instance.collection('users').doc(uid).delete();
    //Todo: 그룹 파이어스토어 삭제

    //로그아웃
    await UserRepository.signOut();
    openAlertDialog(
      title: '계정 탈퇴가 완료되었습니다.',
      function: () {
        SystemNavigator.pop();
      },
    );
  }

  void _uploadFeedback() {
    //Todo: 피드백 업로드
    FirebaseFirestore.instance
        .collection('deletionFeedbacks')
        .doc()
        .set({'surveyResult': surveyResult.value});
  }
}
