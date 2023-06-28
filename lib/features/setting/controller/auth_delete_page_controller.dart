import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AuthDeletePageController extends GetxController {
  ScrollController pageScrollController = ScrollController();
  Rx<String> surveyResult = '자주 사용하지 않아요'.obs;
  TextEditingController feedbackController = TextEditingController();
  Rx<bool> isFeedback = false.obs;

  void authDeletion() async {
    _uploadFeedback();
    //유저 파이어스토어 삭제
    FirebaseFirestore.instance
        .collection('users')
        .doc(AuthController.to.user.value.uid)
        .delete();
    //Todo: 그룹 파이어스토어 삭제

    //auth에서 삭제
    FirebaseAuth.instance.currentUser!.delete();
    //로그아웃
    await UserRepository.signOut();
  }

  void _uploadFeedback() {
    //Todo: 피드백 업로드
    FirebaseFirestore.instance.collection('feedbacks').doc(surveyResult.value);
  }
}
