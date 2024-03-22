import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/src/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/src/helper/background_message/repository/fcm_repository.dart';
import 'package:couple_to_do_list_app/src/helper/open_alert_dialog.dart';
import 'package:couple_to_do_list_app/src/models/device_token_model.dart';
import 'package:couple_to_do_list_app/src/repository/copy_count_repository.dart';
import 'package:couple_to_do_list_app/src/repository/user_repository.dart';
import 'package:couple_to_do_list_app/src/utils/custom_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthDeletePageController extends GetxController {
  ScrollController pageScrollController = ScrollController();
  Rx<String> surveyResult = '자주 사용하지 않아요'.obs;
  TextEditingController feedbackController = TextEditingController();
  Rx<bool> isFeedback = false.obs;

  void authDeletion() async {
    //auth 삭제 전 재인증
    await openAlertDialog(
        title: '삭제',
        content: '원활한 삭제를 위해 계정 인증 부탁드립니다.',
        secondButtonText: '뒤로가기',
        btnText: '인증 후 탈퇴하기',
        mainfunction: () async {
          //uid 임시저장
          String? uid = AuthController.to.user.value.uid;
          String? groupId = AuthController.to.user.value.groupId;
          String? myGender = AuthController.to.user.value.gender;

          //CopyCount 삭제
          CopyCountRepository().deleteCopyCountByUid(uid!);
          //DeviceToken 삭제
          DeviceTokenModel? deviceToken =
              await FCMRepository().getDeviceTokenByUid(uid);
          if (deviceToken != null) {
            FCMRepository().deleteDeviceToken(deviceToken.tid!);
          }
          _uploadFeedback();

          String loginType = await UserRepository.getLoginType();
          if (loginType == 'google') {
            print('로그인타입 구글');
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
            if (customToken == '') {
              openAlertDialog(title: '로그인 실패');
            } else {
              // AuthController.loginType = 'kakao';
              //  print('(kak btn) 로그인 타입 ${AuthController.loginType}');
              await FirebaseAuth.instance.signInWithCustomToken(customToken);
            }
          } else if (loginType == 'apple') {
            await AuthController.to.signInWithApple();
            // print('apple login 성공: nickname = ${AuthController.to.user.value.nickname}');
            //로그인 타입 설정
            // AuthController.loginType = 'apple';
          } else if (loginType == 'guest') {
            print('로그인타입 게스트');
            await Get.dialog(_registerDialog());
          }
          print('1');
          //auth에서 삭제
          await FirebaseAuth.instance.currentUser!.delete();
          print('auth 삭제뒤');
          //유저 파이어스토어 삭제
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .delete();
          print('store 삭제뒤');
          //짝꿍의 user data가 파이어스토어에 없는지 확인 후 group 삭제 진행
          final groupSnapshot = await FirebaseFirestore.instance
              .collection('groups')
              .doc(groupId)
              .get();
          print('2');
          Map<String, dynamic>? data = groupSnapshot.data();
          print('3');
          if (data != null) {
            print('반환');
            String? femaleUid = data['femaleUid'];
            String? maleUid = data['maleUid'];
            String? buddyUid = myGender == 'male' ? femaleUid : maleUid;
            final buddySnapshot = await FirebaseFirestore.instance
                .collection('users')
                .doc(buddyUid)
                .get();
            print('get');
            if (!buddySnapshot.exists) {
              //짝꿍의 user data가 파이어스토어에 없을 떄 (짝꿍이 이미 탈퇴를했을 때) 그룹 삭제진행
              print('그룹 삭제1');
              //subcollection 모두 없애고
              await deleteSubcollection(groupId, 'bukkungLists');
              print('그룹 삭제2');
              await deleteSubcollection(groupId, 'completedBukkungLists');
              print('그룹 삭제3');
              await deleteSubcollection(groupId, 'diary');
              print('그룹 삭제4');
              await deleteSubcollection(groupId, 'notification');
              print('그룹 삭제5');

              //groups 없애고
              await FirebaseFirestore.instance
                  .collection('groups')
                  .doc(groupId)
                  .delete();
              print('group deletion');
              //storage 사진들 없애고
              await deleteFolder('group_bukkunglist/$groupId/');
              print('그룹 삭제');
              await deleteFolder('group_diary/$groupId/');
              print('그룹 삭제');
              //       print('stroage images deletion');
            }
          } else {
            //       print('null반환');
          }
          //로그아웃
          print('4');
          await UserRepository.signOut();
          print('5');
          await openAlertDialog(
            title: '계정 탈퇴가 완료되었습니다.',
          );
          Get.back();
        });
    SystemNavigator.pop();
    exit(0);
  }

  void _uploadFeedback() {
    //Todo: 피드백 업로드
    FirebaseFirestore.instance.collection('deletionFeedbacks').doc().set({
      'surveyResult': surveyResult.value,
      'created_at': DateTime.now(),
    });
  }

  //이건 서브 컬랙션 없애는 매서드
  Future deleteSubcollection(groupId, subcollection) async {
    CollectionReference ref = FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection(subcollection);
    QuerySnapshot snapshot = await ref.get();

    if (snapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot docSnapshot in snapshot.docs) {
        await docSnapshot.reference.delete();
      }
    } else {
      // print('The subcollection $subcollection does not exist.');
    }
  }

//이건 storage folder delete 하는 메서드
  Future<void> deleteFolder(String folderPath) async {
    try {
      print('(auth cont) storage folder 삭제');
      final FirebaseStorage storage = FirebaseStorage.instance;
      print('(auth cont) storage folder 삭제2');
      final Reference folderRef = storage.ref(folderPath);
      print('(auth cont) storage folder 삭제3');
      // List all items (files) in the folder
      final ListResult listResult = await folderRef.listAll();
      print('(auth cont) storage folder 삭제4');
      // Iterate through each item and delete it
      for (final item in listResult.items) {
        await item.delete();
      }
      print('(auth cont) storage folder 삭제완료');
      // Finally, delete the main folder(subdirectory 없으면 이거 필요없어서 주석처리함)
      // await folderRef.delete();
    } catch (e) {
      // Handle any errors that occur during the process
      // print('Error deleting folder: $e');
    }
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Widget _registerDialog() {
    return Dialog(
      child: Container(
        height: 260,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: '이메일'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: '비밀번호'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await AuthController.to.signInWithEmailAndPassword(
                  emailController.text,
                  passwordController.text,
                );
                Get.back();
              },
              child: Text('회원 인증'),
            ),
            SizedBox(height: 10),
            Text(
              '(주의) 이메일과 비밀번호를 분실하신 경우에는 카카오톡으로 문의주세요.',
              style: TextStyle(
                color: CustomColors.greyText,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
