import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/features/auth/pages/find_buddy_page.dart';
import 'package:couple_to_do_list_app/features/auth/pages/signup_page.dart';
import 'package:couple_to_do_list_app/features/auth/pages/welcome_page.dart';
import 'package:couple_to_do_list_app/features/home/pages/home_page.dart';
import 'package:couple_to_do_list_app/models/user_model.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Root extends GetView<AuthController> {
  const Root({Key? key}) : super(key: key);

  Widget loadingContainer() {
    return Container(
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator(
          color: CustomColors.mainPink,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //Todo: 앱 실행시 if문들 들어갔다 나옴, 전부 로딩창으로 정리 필요
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext _, AsyncSnapshot<User?> user) {
        if (user.hasData) {
          print('유저 이메일(root)${user.data!.email}');
          return FutureBuilder<UserModel?>(
            future: controller.loginUser(user.data!.email ?? ''),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                print('로그인 기다리는 중(root)');
                return loadingContainer();
              } else if (snapshot.hasError) {
                print('로그인 오류(root)');
                return loadingContainer();
              } else {
                if (!snapshot.hasData) {
                  print('신규 유저임(root)');
                  // print('유저정보(root) ${controller.user.value.uid}');
                  // print('회원가입하러(root)');
                  return SignupPage(
                    uid: user.data!.uid,
                    email: user.data!.email ?? '',
                  );
                } else {
                  print('로그인 정보 ${controller.user.toJson()}');
                  // if (controller.user.value.uid == null) {
                  //   return LoadingContainer();}
                  if (controller.user.value.groupId == null) {
                    print('groupId 값이 아직 존재하지 않습니다. FindBuddyPage로 이동합니다.');
                    return FindBuddyPage(email: user.data!.email ?? '');
                  } else {
                    print('groupId 값이 존재함. HomePage로 이동합니다.');
                    return HomePage();
                  }
                }
              }
            },
          );
        } else {
          print('firebase가 null반환');
          return WelcomePage();
        }
      },
    );
  }
}
