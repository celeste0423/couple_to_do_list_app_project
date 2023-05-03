import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/features/auth/model/user_model.dart';
import 'package:couple_to_do_list_app/features/auth/pages/signup_page.dart';
import 'package:couple_to_do_list_app/features/auth/pages/welcome_page.dart';
import 'package:couple_to_do_list_app/features/home/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Root extends GetView<AuthController> {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext _, AsyncSnapshot<User?> user) {
        if (!user.hasData) {
          return Center(child: CircularProgressIndicator());
        } else if (user.hasData) {
          print('streambuild(root)');
          return FutureBuilder<UserModel?>(
            //future로 리턴해준 값은 신규 유저여부 판별
            future: controller.loginUser(user.data!.uid),
            builder: (context, snapshot) {
              print('futurebuild(root)');
              if (snapshot.hasData) {
                print('데이터 존재, 홈으로 바로 감(root)');
                return const HomePage();
              } else {
                //future가 완료되기 전 or 완료되었는데 정보가 없는 경우
                print('신규 유저임(root)${controller.user.value.email}');
                return Obx(() {
                  print('유저정보(root) ${controller.user.value.uid}');
                  //controller Rx를 구독하도록 수정
                  if (controller.user.value?.uid != null) {
                    print('로그인 되어있음 홈으로(root)');
                    return const HomePage();
                  } else {
                    print('회원가입하러(root)');
                    return SignupPage(
                      uid: user.data!.uid,
                      email: user.data!.email,
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
      },
    );
  }
}
