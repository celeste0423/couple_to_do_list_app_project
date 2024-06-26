import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/src/helper/background_message/controller/fcm_controller.dart';
import 'package:couple_to_do_list_app/src/models/bukkung_list_model.dart';
import 'package:couple_to_do_list_app/src/models/group_model.dart';
import 'package:couple_to_do_list_app/src/models/user_model.dart';
import 'package:couple_to_do_list_app/src/repository/bukkunglist_repository.dart';
import 'package:couple_to_do_list_app/src/repository/group_repository.dart';
import 'package:couple_to_do_list_app/src/repository/user_repository.dart';
import 'package:couple_to_do_list_app/src/utils/group_util.dart';
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

  int globalPreviousLevel = 0;
  int globalCurrentLevel = 0;
  bool isLevelDialog = false;

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
  // Future<List<int>> getExpPoint() async {
  //   //0번이 exp
  //   //1번이 view
  //   //2번이 like
  //   List<int> expLikeViewCount = List<int>.filled(3, 0);
  //   List<BukkungListModel> bukkungLists =
  //       await SuggestionListRepository().getFutureMyBukkungList();
  //
  //   for (BukkungListModel bukkunglist in bukkungLists) {
  //     expLikeViewCount[1] += bukkunglist.viewCount!.toInt();
  //     // expLikeViewCount[2] += bukkunglist.likeCount!.toInt();
  //   }
  //   //조회수는 1점, 좋아요는 5점
  //   expLikeViewCount[0] = expLikeViewCount[1] * 1 + expLikeViewCount[2] * 5;
  //   //  print('exp계산중(auth cont) 총 ${expLikeViewCount[0]}점');
  //
  //   //이전 exp와 비교하여 레벨이 올랐을 시 level up dialog 표시
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   int? previousLevel = prefs.getInt('user_level');
  //   print('previous Level $previousLevel');
  //   print('지금 레벨 ${expLikeViewCount[0] ~/ 100}');
  //   if (previousLevel != null && previousLevel != expLikeViewCount[0] ~/ 100) {
  //     globalPreviousLevel = previousLevel;
  //     globalCurrentLevel = expLikeViewCount[0] ~/ 100;
  //     isLevelDialog = true;
  //   }
  //   await prefs.setInt('user_level', expLikeViewCount[0] ~/ 100);
  //
  //   return expLikeViewCount;
  // }
  //
  Future<void> signup(UserModel userData) async {
    await UserRepository.firestoreSignup(userData);
    await loginUser(userData.uid!);
  }

//로그인
  Future<UserModel?> loginUser(String uid) async {
    UserModel? userData = await UserRepository.getUserData(uid);

    //fcm 세팅
    fcmInit(uid);

    if (userData != null) {
      user(userData);
      var groupData = await GroupRepository.groupLogin(userData.groupId);
      if (groupData != null) {
        group(groupData);

        // int expPoint = (await getExpPoint())[0];
        // UserModel updatedData = user.value.copyWith(
        //   expPoint: expPoint,
        // );
        // user(updatedData);
      }
    }
    return userData;
  }

  void setUserData(UserModel updatedUserModel) {
    user(updatedUserModel);
  }

  void fcmInit(String uid) async {
    //fcm 세팅(클라우드 메시지)
    var deviceToken = await FCMController().getMyDeviceToken();
    // print('디바이스 토큰 (auth cont) $deviceToken');
    String platform = 'unknown';
    if (Platform.isAndroid) {
      platform = 'android';
    } else if (Platform.isIOS) {
      platform = 'ios';
    }
    FCMController().uploadDeviceToken(deviceToken, uid, platform);

    //fcm 수신
    FCMController().setupInteractedMessage();
  }

  Future<GroupIdStatus> groupCreation(String myEmail, String buddyEmail) async {
    UserModel? myData = await UserRepository.loginUserByEmail(myEmail);
    UserModel? buddyData = await UserRepository.loginUserByEmail(buddyEmail);
    if (myData != null) {
      await checkMyGroup(myData);
    }
    var uuid = Uuid();
    String groupId = uuid.v1();
    if (buddyData == null || myData == null) {
      //아직 짝꿍이 가입 안함 or 내 정보가 없음(오류)
      return GroupIdStatus.noData;
    } else if (buddyData.groupId != null) {
      //상대 그룹 아이디가 존재
      if (GroupUtil().isSoloGroup(buddyData.groupId!)) {
        if (myData.groupId == null) {
          //내가 뉴비 상대는 solo그룹 => 그룹 만들고 하나만 옮기기
          return createSoloGroup(myData, buddyData, groupId);
        } else {
          //나도 solo 상대도 solo => 그룹 합치기
          return mergeSoloGroups(myData, buddyData);
        }
      } else {
        //이미 짝이 있음
        //다른 짝이 나인지 확인할 것
        if (buddyData.groupId == myData.groupId) {
          return GroupIdStatus.createdGroupId;
        }
        return GroupIdStatus.hasGroup;
      }
    } else {
      //상대 그룹아이디가 아직 없음
      if (myData.groupId != null) {
        //내가 solo 상대가 new
        return createSoloGroup(buddyData, myData, groupId);
      } else {
        //나는 아직 solo그룹이 없음 => 새로운 그룹 만들어서 둘다 가입
        if (myData.gender == 'male') {
          return groupSignup(myData, buddyData, groupId);
        } else if (myData.gender == 'female') {
          return groupSignup(buddyData, myData, groupId);
        } else {
          //동성 커플고려는 아직은 하지 않는걸로
          var groupData =
              await GroupRepository.groupSignup(groupId, myData, buddyData);
          group(groupData);
          return GroupIdStatus.createdGroupId;
        }
      }
    }
  }

  Future checkMyGroup(UserModel myData) async {
    //내 uid가 포함된 그룹이 이미 존재한다면 바로 페이지 넘어갈 수 있도록. 그 그룹id를 내 정보에 넣기
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    String myUid = myData!.uid!;
    if (myData.gender == 'male') {
      // Query snapshots where 'femaleUid' equals the provided UID
      var maleQuerySnapshot = await firestore
          .collection('group')
          .where('maleUid', isEqualTo: myUid)
          .get();
      if (maleQuerySnapshot.docs.isNotEmpty) {
        List notSoloGroupDatas = [];
        for (var doc in maleQuerySnapshot.docs) {
          var data = doc.data();
          if (!data['uid'].contains('solo')) {
            notSoloGroupDatas.add(data);
          }
        }
        if (notSoloGroupDatas.isNotEmpty) {
          Map<String, dynamic> data = notSoloGroupDatas[0].data();
          String groupId = data['uid'];
          myData.copyWith(groupId: groupId);
          user(myData);
          group(GroupModel.fromJson(data));
          await UserRepository.updateGroupId(myData, groupId);
          // Delete the other documents
          if (notSoloGroupDatas.length > 1) {
            for (var data in notSoloGroupDatas.skip(1)) {
              await firestore.collection('group').doc(data['uid']).delete();
            }
          }
          return GroupIdStatus.createdGroupId;
        }
      }
    } else if (myData.gender == 'female') {
      // Query snapshots where 'femaleUid' equals the provided UID
      var femaleQuerySnapshot = await firestore
          .collection('group')
          .where('femaleUid', isEqualTo: myUid)
          .get();
      if (femaleQuerySnapshot.docs.isNotEmpty) {
        List notSoloGroupDatas = [];
        for (var doc in femaleQuerySnapshot.docs) {
          var data = doc.data();
          if (!data['uid'].contains('solo')) {
            notSoloGroupDatas.add(data);
          }
        }
        if (notSoloGroupDatas.isNotEmpty) {
          Map<String, dynamic> data = notSoloGroupDatas[0].data();
          String groupId = data['uid'];
          myData.copyWith(groupId: groupId);
          user(myData);
          group(GroupModel.fromJson(data));
          await UserRepository.updateGroupId(myData, groupId);
          // Delete the other documents
          if (notSoloGroupDatas.length > 1) {
            for (var data in notSoloGroupDatas.skip(1)) {
              await firestore.collection('group').doc(data['uid']).delete();
            }
          }
          return GroupIdStatus.createdGroupId;
        }
      }
    }
  }

  Future<GroupIdStatus> createSoloGroup(
    UserModel noGroupUserData,
    UserModel hasGroupUserData,
    String groupId,
  ) async {
    var groupData = await GroupRepository()
        .updateSoloGroup(noGroupUserData, hasGroupUserData);
    group(groupData);
    await UserRepository.updateGroupId(noGroupUserData, groupData!.uid!);
    await UserRepository.updateGroupId(hasGroupUserData, groupData.uid!);
    //user에 그룹아이디 주입
    user(noGroupUserData.copyWith(groupId: groupId));
    return GroupIdStatus.createdGroupId;
  }

  Future<GroupIdStatus> mergeSoloGroups(
    UserModel myData,
    UserModel buddyData,
  ) async {
    if (AuthController.to.user.value.gender == 'male') {
      var groupData = await GroupRepository().mergeSoloGroup(myData, buddyData);
      group(groupData);
      await UserRepository.updateGroupId(myData, groupData!.uid!);
      await UserRepository.updateGroupId(buddyData, groupData.uid!);
    } else {
      var groupData = await GroupRepository().mergeSoloGroup(buddyData, myData);
      group(groupData);
      await UserRepository.updateGroupId(myData, groupData!.uid!);
      await UserRepository.updateGroupId(buddyData, groupData.uid!);
    }
    return GroupIdStatus.createdGroupId;
  }

  Future<GroupIdStatus> groupSignup(
    UserModel user1,
    UserModel user2,
    String groupId,
  ) async {
    var groupData = await GroupRepository.groupSignup(groupId, user1, user2);
    group(groupData);
    await UserRepository.updateGroupId(user1, groupId);
    await UserRepository.updateGroupId(user2, groupId);
    user(user1.copyWith(groupId: groupId));

    // 기본 버꿍리스트 업로드
    BukkungListModel initialBukkungList = BukkungListModel(
      listId: 'initial$groupId',
      category: '6etc',
      title: '함께 버꿍리스트 앱 설치하기',
      content:
          '우리 함께 꿈꾸던 버킷리스트들을 하나 둘 실천해보자,\n\n사진과 함께 예쁜 다이어리도 만들고\n행복한 추억을 차곡차곡 쌓아나가자!❤️',
      location: '버꿍리스트',
      imgUrl: null,
      imgId: null,
      viewCount: 0,
      copyCount: 0,
      date: DateTime.now(),
      madeBy: AuthController.to.user.value.uid,
      groupId: groupId,
      isCompleted: false,
      createdAt: DateTime.now(),
      updatedAt: null,
    );
    await BukkungListRepository()
        .setGroupBukkungList(initialBukkungList, 'initial$groupId');
    return GroupIdStatus.createdGroupId;
  }

  Future soloGroupCreation(String myEmail) async {
    UserModel? myData = await UserRepository.loginUserByEmail(myEmail);
    UserModel? nullBuddyData = myData!.copyWith(uid: 'solo');
    var uuid = Uuid();
    String groupId = 'solo${uuid.v1()}';

    if (myData.gender == 'male') {
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
    BukkungListModel initialBukkungList = BukkungListModel(
      listId: 'initial$groupId',
      category: '6etc',
      title: '함께 버꿍리스트 앱 설치하기',
      content:
          '우리 함께 꿈꾸던 버킷리스트들을 하나 둘 실천해보자,\n\n사진과 함께 예쁜 다이어리도 만들고\n행복한 추억을 차곡차곡 쌓아나가자!❤️',
      location: '버꿍리스트',
      imgUrl: null,
      imgId: null,
      viewCount: 0,
      copyCount: 0,
      date: DateTime.now(),
      madeBy: AuthController.to.user.value.uid,
      groupId: groupId,
      isCompleted: false,
      createdAt: DateTime.now(),
      updatedAt: null,
    );
    await BukkungListRepository()
        .setGroupBukkungList(initialBukkungList, 'initial$groupId');
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
