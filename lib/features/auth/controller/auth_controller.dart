import 'dart:async';

import 'package:couple_to_do_list_app/binding/init_binding.dart';
import 'package:couple_to_do_list_app/features/auth/repository/group_repository.dart';
import 'package:couple_to_do_list_app/features/auth/repository/user_repository.dart';
import 'package:couple_to_do_list_app/helper/show_alert_dialog.dart';
import 'package:couple_to_do_list_app/models/group_model.dart';
import 'package:couple_to_do_list_app/models/user_model.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

enum GroupIdStatus { noData, hasGroup, createdGroupId }

class AuthController extends GetxController {
  static AuthController get to => Get.find();
  Rx<UserModel> user = UserModel().obs;
  Rx<GroupModel> group = GroupModel().obs;

  Future<UserModel?> loginUser(String email) async {
    try {
      var userData = await UserRepository.loginUserByEmail(email);
      var groupData = await GroupRepository.groupLogin(userData!.groupId ?? '');
      //신규 유저일 경우 userData에 null값 반환됨
      if (userData != null) {
        print('서버의 유저 데이터 (cont) ${userData.toJson()}');
        user(userData);
        // InitBinding.additionalBinding(); //bukkungListPageController 바인딩
      }
      if (groupData != null) {
        print('서버의 그룹 데이터(auth cont)${groupData.toJson()}');
        group(groupData);
        print('그룹 정보(auth cont)${group.value.uid}');
        InitBinding.additionalBinding();
      }
      return userData; //신규 유저일 경우 null반환
    } catch (e) {
      print('loginUser 오류(cont)$e');
      openAlertDialog(message: '로그인 오류${e.toString()}');
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
      var groupdata =
          await GroupRepository.groupSignup(groupId, myData, buddyData!);
      group(groupdata);
    } else if (myData!.gender == 'female') {
      var groupdata =
          await GroupRepository.groupSignup(groupId, buddyData!, myData);
      group(groupdata);
    } else {
      //동성 커플고려는 아직은 하지 않는걸로
      var groupdata =
          await GroupRepository.groupSignup(groupId, myData, buddyData!);
      group(groupdata);
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

  // Future<GroupModel> saveGroupData() async {
  //   print('받아온 유저 데이터(auth cont) ${user.value.groupId}');
  //   var groupData = await GroupRepository.groupLogin(user.value.groupId ?? '');
  //   print('그룹 데이터 (auth cont) ${groupData!.uid}');
  //   group(groupData);
  //   print('그룹 데이터 저장 (auth cont) ${group.value.uid}');
  //   return group.value;
  // }
}

//카카오 user registration

// static AuthController instance = Get.find();
// late Rx<User?> _user;
// FirebaseAuth authentication = FirebaseAuth.instance;
//
// @override
// void onReady() {
//   super.onReady();
//   _user = Rx<User?>(authentication.currentUser);
//   _user.bindStream(authentication.userChanges());
//   ever(_user, _moveToPage);
// }
//
// _moveToPage(User? user) {
//   if (user == null) {
//     Get.offAll(() => WelcomePage());
//   } else {
//     Get.offAll(() => SignupPage());
//   }
// }
//
// void register(String email, password) async {
//   try {
//     await authentication.createUserWithEmailAndPassword(
//         email: email, password: password);
//   } catch (e) {
//     Get.snackbar(
//       "Error message",
//       "User message",
//       backgroundColor: Colors.red,
//       snackPosition: SnackPosition.BOTTOM,
//       titleText: Text(
//         "Registration is failed",
//         style: TextStyle(color: Colors.white),
//       ),
//       messageText: Text(
//         e.toString(),
//         style: TextStyle(color: Colors.white),
//       ),
//     );
//   }
// }
//
// void logout() {
//   authentication.signOut();
