import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/helper/background_message/repository/fcm_repository.dart';
import 'package:couple_to_do_list_app/helper/open_alert_dialog.dart';
import 'package:couple_to_do_list_app/models/device_token_model.dart';
import 'package:couple_to_do_list_app/repository/copy_count_repository.dart';
import 'package:couple_to_do_list_app/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
            if (customToken == '') {
              openAlertDialog(title: '로그인 실패');
            } else {
              // AuthController.loginType = 'kakao';
              //  print('(kak btn) 로그인 타입 ${AuthController.loginType}');
              await FirebaseAuth.instance.signInWithCustomToken(customToken);
            }
          } else if (loginType == 'apple') {
            await AuthController.to.signInWithApple();
            //print('apple login 성공: nickname = ${AuthController.to.user.value.nickname}');
            //로그인 타입 설정
            // AuthController.loginType = 'apple';
          }
          //auth에서 삭제
          await FirebaseAuth.instance.currentUser!.delete();
          //  print('auth 삭제뒤');
          //유저 파이어스토어 삭제
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .delete();
          //  print('store 삭제뒤');

          //짝꿍의 user data가 파이어스토어에 없는지 확인 후 group 삭제 진행
          final snapshot1 = await FirebaseFirestore.instance
              .collection('groups')
              .doc(groupId)
              .get();

          Map<String, dynamic>? data = snapshot1.data();
          if (data != null) {
            //    print('반환');
            String? femaleUid = data['femaleUid'];
            String? maleUid = data['maleUid'];
            String? bukkungUid = myGender == 'male' ? femaleUid : maleUid;
            final snapshot2 = await FirebaseFirestore.instance
                .collection('users')
                .doc(bukkungUid)
                .get();
            //      print('get');
            if (!snapshot2.exists) {
              //짝꿍의 user data가 파이어스토어에 없을 떄 (짝꿍이 이미 탈퇴를했을 때) 그룹 삭제진행

              //subcollection 모두 없애고
              await deleteSubcollection(groupId, 'bukkungLists');
              await deleteSubcollection(groupId, 'completedBukkungLists');
              await deleteSubcollection(groupId, 'diary');
              await deleteSubcollection(groupId, 'notification');

              //groups 없애고
              await FirebaseFirestore.instance
                  .collection('groups')
                  .doc(groupId)
                  .delete();
              //   print('group deletion');
              //storage 사진들 없애고
              await deleteFolder('group_bukkunglist/$groupId/');
              await deleteFolder('group_diary/$groupId/');
              //       print('stroage images deletion');
            }
          } else {
            //       print('null반환');
          }

          //CopyCount 삭제
          CopyCountRepository().deleteCopyCountByUid(uid!);
          //DeviceToken 삭제
          DeviceTokenModel? deviceToken =
              await FCMRepository().getDeviceTokenByUid(uid);
          if (deviceToken != null) {
            FCMRepository().deleteDeviceToken(deviceToken.tid!);
          }

          _uploadFeedback();
          //로그아웃
          await UserRepository.signOut();
          await openAlertDialog(
            title: '계정 탈퇴가 완료되었습니다.',
          );
          Get.back();
        });
    SystemNavigator.pop();
  }

  void _uploadFeedback() {
    //Todo: 피드백 업로드
    FirebaseFirestore.instance.collection('deletionFeedbacks').doc().set({
      'surveyResult': surveyResult.value,
      'created_at': DateTime.now(),
    });
  }
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
    final FirebaseStorage storage = FirebaseStorage.instance;
    final Reference folderRef = storage.ref(folderPath);
    // List all items (files) in the folder
    final ListResult listResult = await folderRef.listAll();
    // Iterate through each item and delete it
    for (final item in listResult.items) {
      await item.delete();
    }
    // Finally, delete the main folder(subdirectory 없으면 이거 필요없어서 주석처리함)
    // await folderRef.delete();
  } catch (e) {
    // Handle any errors that occur during the process
    // print('Error deleting folder: $e');
  }
}
