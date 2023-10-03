import 'package:couple_to_do_list_app/binding/init_binding.dart';
import 'package:couple_to_do_list_app/features/admin_management/pages/admin_management.dart';
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
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext _, AsyncSnapshot<User?> user) {
        if (user.hasData) {
          // print('user data (root)${user.data}');
          // print('유저 이메일(root)${user.data!.email}');
          return FutureBuilder<UserModel?>(
            future: controller.loginUser(user.data!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                //     print('로그인 기다리는 중(root)');
                return loadingContainer();
              } else if (snapshot.hasError) {
                //  print('로그인 오류(root)');
                return loadingContainer();
              } else {
                if (!snapshot.hasData) {
                  //   print('신규 유저임(root)');
                  // print('유저정보(root) ${controller.user.value.uid}');
                  // print('user.data!.uid ${user.data!.uid}');
                  //일단 controller에 uid와 email처음 저장
                  controller.user(
                      UserModel(uid: user.data!.uid, email: user.data!.email));
                  // print('유저정보(root) ${controller.user.value.uid}');
                  return SignupPage(
                    uid: user.data!.uid,
                    email: user.data!.email ?? '',
                  );
                } else {
                  // print('로그인 정보 ${controller.user.toJson()}');
                  if (user.data!.email == 'bukkunglist@gmail.com') {
                    //  print('관리자 계정으로 로그인했습니다. ManagementPage로 이동합니다.');
                    return AdminPage();
                  } else if (controller.user.value.groupId == null) {
                    //  print('groupId 값이 아직 존재하지 않습니다. FindBuddyPage로 이동합니다.');
                    return FindBuddyPage(email: user.data!.email ?? '');
                  } else {
                    //  print('groupId 값이 존재함. homepage 가기 직전 initbinding실행');
                    InitBinding.additionalBinding();
                    // print('HomePage로 이동.');
                    return HomePage();
                  }
                }
              }
            },
          );
        } else {
          //  print('firebase가 null반환');
          return WelcomePage();
        }
      },
    );
  }
}
