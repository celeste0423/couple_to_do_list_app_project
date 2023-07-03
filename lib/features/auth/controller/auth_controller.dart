import 'dart:async';

import 'package:couple_to_do_list_app/helper/show_alert_dialog.dart';
import 'package:couple_to_do_list_app/models/group_model.dart';
import 'package:couple_to_do_list_app/models/user_model.dart';
import 'package:couple_to_do_list_app/repository/group_repository.dart';
import 'package:couple_to_do_list_app/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

enum GroupIdStatus { noData, hasGroup, createdGroupId }

class AuthController extends GetxController {
  static AuthController get to => Get.find();
  static String? loginType;

  Rx<UserModel> user = UserModel().obs;
  // Rx<UserModel> user = UserModel(uid: 'base').obs;
  Rx<GroupModel> group = GroupModel().obs;
  // final finishedLogin = false.obs;

  //구글 로그인
  Future<UserCredential> signInWithGoogle() async {
    return await UserRepository.signInWithGoogle();
  }

  //카카오로그인
  Future<String> signInWithKakao() async {
    return await UserRepository.signInWithKakao();
  }

  Future<UserModel?> loginUser(String email) async {
    try {
      //email과 맞는 유저 데이터를 firebase 에서 가져온다.
      var userData = await UserRepository.loginUserByEmail(email);
      //신규 유저일 경우 userData에 null값 반환됨
      if (userData != null) {
        //컨트롤러에 유저정보를 전달해 놓는다
        print('서버의 유저 데이터 (cont) ${userData.toJson()}');
        user(userData);
        var groupData = await GroupRepository.groupLogin(userData.groupId);
        if (groupData != null) {
          print('서버의 그룹 데이터(auth cont)${groupData.toJson()}');
          group(groupData);
          print('그룹 정보(auth cont)${group.value.uid}');
          //InitBinding.additionalBinding();
        }
      }
      return userData; //로딩 중 경우 null반환
    } catch (e) {
      print('loginUser 오류(cont)$e');
      openAlertDialog(title: '로그인 오류${e.toString()}');
      return null;
    }
  }

  Future signup(UserModel signupUser) async {
    //회원가입 버튼에 사용
    var result = await UserRepository.firestoreSignup(signupUser);
    if (result) {
      loginUser(signupUser.email!);
    }
  }

  Future<GroupIdStatus> groupCreation(String myEmail, String buddyEmail) async {
    var myData = await UserRepository.loginUserByEmail(myEmail);
    var buddyData = await UserRepository.loginUserByEmail(buddyEmail);

    var uuid = Uuid();
    String groupId = uuid.v1();

    if (myData!.gender == 'male') {
      var groupData =
          await GroupRepository.groupSignup(groupId, myData, buddyData!);
      group(groupData);
    } else if (myData!.gender == 'female') {
      var groupData =
          await GroupRepository.groupSignup(groupId, buddyData!, myData);
      group(groupData);
    } else {
      //동성 커플고려는 아직은 하지 않는걸로
      var groupData =
          await GroupRepository.groupSignup(groupId, myData, buddyData!);
      group(groupData);
    }

    if (buddyData == null || myData == null) {
      print('buddyData 없음(cont) ${buddyData}');
      return GroupIdStatus.noData;
    } else if (buddyData.groupId != null) {
      print('짝꿍이 이미 다른 짝이 있음');
      return GroupIdStatus.hasGroup;
    } else {
      print('uuid로 가입 시작(cont) ${groupId}');
      await UserRepository.updateGroupId(myData, groupId);
      await UserRepository.updateGroupId(buddyData, groupId);
      return GroupIdStatus.createdGroupId;
    }
  }

  Future<bool> findGroupId(String email) async {
    return await UserRepository.findGroupId(email);
  }
}
