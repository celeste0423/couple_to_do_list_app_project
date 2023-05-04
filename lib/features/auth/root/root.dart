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

class Root extends GetView<AuthController> {
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
    print(controller.user.value.uid);
    return StreamBuilder<UserModel?>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(controller.user.value.uid)
          .snapshots()
          .map(_userModelFromSnapshot),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var userModel = snapshot.data!;
          if (userModel.groupId != null) {
            // groupId가 존재하는 경우 HomePage로 이동
            return HomePage();
          } else {
            // groupId가 존재하지 않는 경우 FirebaseAuth의 변화를 감지하며 초기화면 실행
            return StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var user = snapshot.data!;
                  return FutureBuilder<UserModel?>(
                    future: controller.loginUser(user.email ?? ''),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return FindBuddyPage(email: user.email ?? '');
                      } else {
                        return SignupPage(
                          uid: user.uid,
                          email: user.email ?? '',
                        );
                      }
                    },
                  );
                } else {
                  return WelcomePage();
                }
              },
            );
          }
        } else {
          // 사용자 정보가 로드되지 않은 경우, 로그인 되어있는지 확인하여 초기화면 실행
          if (controller.user.value != null) {
            return StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var user = snapshot.data!;
                  return FutureBuilder<UserModel?>(
                    future: controller.loginUser(user.email ?? ''),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return FindBuddyPage(email: user.email ?? '');
                      } else {
                        return SignupPage(
                          uid: user.uid,
                          email: user.email ?? '',
                        );
                      }
                    },
                  );
                } else {
                  return WelcomePage();
                }
              },
            );
          } else {
            return WelcomePage();
          }
        }
      },
    );
  }
}
