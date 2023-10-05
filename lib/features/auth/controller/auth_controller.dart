import 'dart:async';

import 'package:couple_to_do_list_app/constants/constants.dart';
import 'package:couple_to_do_list_app/helper/open_alert_dialog.dart';
import 'package:couple_to_do_list_app/models/bukkung_list_model.dart';
import 'package:couple_to_do_list_app/models/group_model.dart';
import 'package:couple_to_do_list_app/models/user_model.dart';
import 'package:couple_to_do_list_app/repository/bukkung_list_repository.dart';
import 'package:couple_to_do_list_app/repository/group_repository.dart';
import 'package:couple_to_do_list_app/repository/list_suggestion_repository.dart';
import 'package:couple_to_do_list_app/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:uuid/uuid.dart';

enum GroupIdStatus { noData, hasGroup, createdGroupId }

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  //유저 정보
  static String? loginType;

  Rx<UserModel> user = UserModel().obs;
  Rx<GroupModel> group = GroupModel().obs;

  // StreamController<UserModel> streamUserController =
  //     StreamController<UserModel>();
  // late Stream<UserModel> streamUser = streamUserController.stream;
  // StreamController<GroupModel> streamGroupController =
  //     StreamController<GroupModel>();
  // late Stream<GroupModel> streamGroup = streamGroupController.stream;
  //
  // @override
  // void onInit() {
  //   super.onInit();
  //   _initUserData();
  //   _initGroupData();
  // }
  //
  // void _initUserData() {
  //   streamUser = UserRepository.streamUserDataByUid(user.value.uid!);
  // }
  //
  // void _initGroupData() {
  //   streamGroup = GroupRepository.streamGroupDataByUid(group.value.uid!);
  // }
  //
  // @override
  // void onClose() {
  //   super.onClose();
  //   streamUserController.close();
  //   streamGroupController.close();
  // }

  //이메일 비밀번호 로그인
  Future signInWithEmailAndPassword(String email, String password) async {
    await UserRepository().signUpWithEmailAndPassword(email, password);
  }

// 애플 로그인
  Future<UserCredential> signInWithApple() async {
    bool isAvailable = await SignInWithApple.isAvailable();
    bool isAndroid =
        foundation.defaultTargetPlatform == foundation.TargetPlatform.android;

    if (isAvailable) {
      if (isAndroid) {
        return await UserRepository.androidSignInWithApple();
      } else {
        return await UserRepository.iosSignInWithApple();
      }
    } else {
      return await UserRepository.appleFlutterWebAuth();
    }
  }

  //구글 로그인
  Future<UserCredential> signInWithGoogle() async {
    return await UserRepository.signInWithGoogle();
  }

  //카카오로그인
  Future<String> signInWithKakao() async {
    return await UserRepository.signInWithKakao();
  }

  //expPoint계산 해주는 함수
  Future<List<int>> getExpPoint() async {
    //0번이 exp
    //1번이 view
    //2번이 like
    List<int> expLikeViewCount = List<int>.filled(3, 0);
    List<BukkungListModel> bukkungLists =
        await ListSuggestionRepository().getFutureMyBukkungList();

    for (BukkungListModel bukkunglist in bukkungLists) {
      expLikeViewCount[1] += bukkunglist.viewCount!.toInt();
      expLikeViewCount[2] += bukkunglist.likeCount!.toInt();
    }
    //조회수는 1점, 좋아요는 5점
    expLikeViewCount[0] = expLikeViewCount[1] * 1 + expLikeViewCount[2] * 5;
    //  print('exp계산중(auth cont) 총 ${expLikeViewCount[0]}점');
    return expLikeViewCount;
  }

  signup(UserModel signupUser) async {
    //회원가입 버튼에 사용
    bool result = await UserRepository.firestoreSignup(signupUser);
    //user 정보를 firebase에 저장하고, result가 true면 유저정보가 firebase database를 넣었고 아니면 에러임
    if (result) {
      //유저정보를 파베에 넣고나서 할일
      //  print("싸인업 : 유저에 ${signupUser.nickname} 넣음");
      user(signupUser);
    } else {
      //   print("error: firestoreSignup");
    }
  }

  Future<UserModel?> loginUser(String uid) async {
    try {
      //email과 맞는 유저 데이터를 firebase 에서 가져온다.
      //  print('(auth cont) uid $uid');
      var userData = await UserRepository.loginUserByUid(uid);
      //신규 유저일 경우 userData에 false값 반환됨, error났을떄는 null 반환됨
      if (userData != null && userData != false) {
        //신규유저가 아닐경우 컨트롤러에 유저정보를 전달해 놓는다
        //   print('서버의 유저 데이터 (cont) ${userData.toJson()}');
        user(userData);
        var groupData = await GroupRepository.groupLogin(userData.groupId);
        if (groupData != null) {
          //   print('서버의 그룹 데이터(auth cont)${groupData.toJson()}');
          group(groupData);
          //  print('그룹 정보(auth cont)${group.value.uid}');

          int expPoint = (await getExpPoint())[0];
          UserModel updatedData = user.value.copyWith(
            expPoint: expPoint,
          );
          user(updatedData);
        }
        return userData;
      } else if (userData == false) {
        //  print('loginUser false');
        return null;
      } else {
        //  print('loginUser error');
        return null;
      }
    } catch (e) {
      // print('loginUser 오류(cont)$e');
      openAlertDialog(title: '로그인 오류${e.toString()}');
      return null;
    }
  }

  Future<GroupIdStatus> groupCreation(String myEmail, String buddyEmail) async {
    //todo:mydata 이거 authcontroller정보 쓰면 더 좋을듯
    var myData = await UserRepository.loginUserByEmail(myEmail);
    var buddyData = await UserRepository.loginUserByEmail(buddyEmail);

    var uuid = Uuid();
    String groupId = uuid.v1();

    if (buddyData == null || myData == null) {
      //아직 짝꿍이 가입 안함
      return GroupIdStatus.noData;
    } else if (buddyData != null && buddyData.groupId != null) {
      if (buddyData.groupId!.startsWith("solo")) {
        if (AuthController.to.group == null) {
          //내가 뉴비 상대는 solo그룹 => 그룹 만들고 하나만 옮기기
          var groupData =
              await GroupRepository().updateSoloGroup(myData, buddyData);
          group(groupData);
          await UserRepository.updateGroupId(myData, groupData!.uid!);
          await UserRepository.updateGroupId(buddyData, groupData!.uid!);
          //user에 그룹아이디 주입
          //todo: groupid 이거 쓰는게 맞나?
          user(myData.copyWith(groupId: groupId));
        } else {
          //나도 solo 상대도 solo => 그룹 합치기
          if (AuthController.to.user.value.gender == 'male') {
            var groupData =
                await GroupRepository().mergeSoloGroup(myData, buddyData);
            group(groupData);
            await UserRepository.updateGroupId(myData, groupData!.uid!);
            await UserRepository.updateGroupId(buddyData, groupData!.uid!);
            //todo: user(myData.copyWith(groupId: groupId)); 이런식으로 해줘야 되는거 아닌가
          } else {
            var groupData =
                await GroupRepository().mergeSoloGroup(buddyData, myData);
            group(groupData);
            await UserRepository.updateGroupId(myData, groupData!.uid!);
            await UserRepository.updateGroupId(buddyData, groupData!.uid!);
            //todo: user(myData.copyWith(groupId: groupId)); 이런식으로 해줘야 되는거 아닌가
          }
        }
        return GroupIdStatus.createdGroupId;
      } else {
        //이미 다른 짝이 있음
        return GroupIdStatus.hasGroup;
      }
    } else {
      //(buddyData != null && buddyData.groupId == null)
      if (myData.groupId != null) {
        //내가 solo 상대가 new
        var groupData =
            await GroupRepository().updateSoloGroup(buddyData, myData);
        group(groupData);
        await UserRepository.updateGroupId(myData, groupData!.uid!);
        await UserRepository.updateGroupId(buddyData, groupData!.uid!);
        //user에 그룹아이디 주입
        //todo: groupid 이거 쓰는게 맞나?
        user(myData.copyWith(groupId: groupId));
        return GroupIdStatus.createdGroupId;
      } else {
        if (myData.gender == 'male') {
          var groupData =
              await GroupRepository.groupSignup(groupId, myData, buddyData);
          //  print('그룹 데이터 ${groupData.uid}');
          group(groupData);
        } else if (myData.gender == 'female') {
          var groupData =
              await GroupRepository.groupSignup(groupId, buddyData, myData);
          //  print('그룹 데이터 ${groupData.uid}');
          group(groupData);
        } else {
          //동성 커플고려는 아직은 하지 않는걸로
          // var groupData =
          //     await GroupRepository.groupSignup(groupId, myData, buddyData!);
          // group(groupData);
        }

        // print('uuid로 가입 시작(cont) $groupId');
        await UserRepository.updateGroupId(myData, groupId);
        await UserRepository.updateGroupId(buddyData, groupId);
        //user에 그룹아이디 주입
        user(myData.copyWith(groupId: groupId));

        //기본 버꿍리스트 업로드
        BukkungListModel initialModel = BukkungListModel.init(user.value);
        BukkungListModel initialBukkungList = initialModel.copyWith(
          title: '함께 버꿍리스트 앱 설치하기',
          listId: 'initial$groupId',
          category: '6etc',
          location: '버꿍리스트 앱',
          content:
              '우리 함께 꿈꾸던 버킷리스트들을 하나 둘 실천해보자,\n\n사진과 함께 예쁜 다이어리도 만들고\n행복한 추억을 차곡차곡 쌓아나가자!❤️',
          imgUrl: Constants.baseImageUrl,
        );
        // print('(auth cont) 기본 버꿍리스트 업로드 시작');
        await BukkungListRepository.setGroupBukkungList(
            initialBukkungList, 'initial$groupId', groupId);
        return GroupIdStatus.createdGroupId;
      }
    }
  }

  Future soloGroupCreation(String myEmail) async {
    UserModel? myData = await UserRepository.loginUserByEmail(myEmail);
    UserModel? nullBuddyData = myData!.copyWith(uid: 'solo');
    var uuid = Uuid();
    String groupId = 'solo${uuid.v1()}';

    if (myData!.gender == 'male') {
      var groupData =
          await GroupRepository.groupSignup(groupId, myData, nullBuddyData);
      // print('그룹 데이터 ${groupData.uid}');
      group(groupData);
    } else if (myData.gender == 'female') {
      var groupData =
          await GroupRepository.groupSignup(groupId, nullBuddyData, myData);
      // print('그룹 데이터 ${groupData.uid}');
      group(groupData);
    } else {
      //동성 커플고려는 아직은 하지 않는걸로
      // var groupData =
      //     await GroupRepository.groupSignup(groupId, myData, buddyData!);
      // group(groupData);
    }

    //print('uuid로 solo 가입 시작(cont) $groupId');
    await UserRepository.updateGroupId(myData, groupId);
    //user에 그룹아이디 주입
    user(myData.copyWith(groupId: groupId));

    //기본 버꿍리스트 업로드
    BukkungListModel initialModel = BukkungListModel.init(user.value);
    BukkungListModel initialBukkungList = initialModel.copyWith(
      title: '함께 버꿍리스트 앱 설치하기',
      listId: 'initial$groupId',
      category: '6etc',
      location: '버꿍리스트 앱',
      content:
          '우리 함께 꿈꾸던 버킷리스트들을 하나 둘 실천해보자,\n\n사진과 함께 예쁜 다이어리도 만들고\n행복한 추억을 차곡차곡 쌓아나가자!❤️',
      imgUrl: Constants.baseImageUrl,
    );
    // print('(auth cont) 기본 버꿍리스트 업로드 시작');
    await BukkungListRepository.setGroupBukkungList(
        initialBukkungList, 'initial$groupId', groupId);
    return GroupIdStatus.createdGroupId;
  }

  Future<GroupModel?> getGroupModel(String email) async {
    //print('그룹 있는지 bool ${await UserRepository.getGroupModel(email)}');
    return await UserRepository.getGroupModel(email);
  }

  clearAuthController() {
    loginType = null;
    group(GroupModel());
    user(UserModel());
  }
}
