import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/features/auth/model/user_model.dart';
import 'package:couple_to_do_list_app/features/auth/pages/find_buddy_page.dart';
import 'package:couple_to_do_list_app/features/auth/pages/signup_page.dart';
import 'package:couple_to_do_list_app/features/auth/pages/welcome_page.dart';
import 'package:couple_to_do_list_app/features/home/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Root extends GetView {
  // final controller = AuthController();
  final AuthController controller = Get.put(AuthController());

  UserModel? _userModelFromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.exists) {
      final data = snapshot.data()!;
      return UserModel(
        uid: data['uid'],
        nickname: data['nickname'],
        email: data['email'],
        gender: data['gender'],
        birthday: data['birthday'],
        groupId: data['groupId'],
        dayMet: data['dayMet'],
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Stream<User?> firebaseAuthStream = FirebaseAuth.instance.authStateChanges();
    Stream<UserModel?> firestoreUsersStream = FirebaseFirestore.instance
        .collection('users')
        .doc(controller.user.value.uid)
        .snapshots()
        .map(_userModelFromSnapshot);

    StreamZip combinedStream =
        StreamZip([firebaseAuthStream, firestoreUsersStream]);

    return StreamBuilder(
        // stream: FirebaseFirestore.instance.collection(collectionPath),
        stream: combinedStream,
        builder: (BuildContext _, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            var user = snapshot.data![0]; //authStream
            var userModel = snapshot.data![1].data; //firestoreStream
            if (userModel != null) {
              print('그룹 존재, 홈으로 바로 감(root)');
              return HomePage();
            } else if (user.hasData) {
              return FutureBuilder<UserModel?>(
                //future로 리턴해준 값은 신규 유저여부 판별
                future: controller.loginUser(user.data!.email ?? ''),
                //Todo: 복귀유저가 로그인 해서 분명 snapshot에 데이터가 있을 텐데 findbuddy로 안감
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print('로그인 정보 존재(root)');
                    return FindBuddyPage(email: user.data!.email ?? '');
                  } else {
                    //future가 완료되기 전 or 완료되었는데 정보가 없는 경우
                    print('신규 유저임(root)${controller.user.value.email}');
                    return Obx(() {
                      print('유저정보(root) ${controller.user.value.uid}');
                      //controller Rx를 구독하도록 수정
                      if (controller.user.value.uid != null) {
                        print('로그인 되어있음 버꿍찾기로(root)');
                        return FindBuddyPage(email: user.data!.email ?? '');
                      } else {
                        print('회원가입하러(root)');
                        return SignupPage(
                          uid: user.data!.uid,
                          email: user.data!.email ?? '',
                        );
                      }
                    });
                  }
                },
              );
            } else {
              print('firebase가 null반환');
              return WelcomePage();
            }
          } else {
            return WelcomePage();
          }
          ;
        });
  }
}
