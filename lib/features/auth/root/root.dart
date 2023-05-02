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
        if (user.hasData) {
          return FutureBuilder<UserModel?>(
            //future로 리턴해준 값은 신규 유저여부 판별
            future: controller.loginUser(user.data!.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print('데이터 존재, 홈으로 바로 감');
                return const HomePage();
              } else {
                //future에 null값 반환받음
                print('신규 유저임');
                return Obx(() {
                  //controller Rx를 구독하고 있음
                  if (controller.user.value.uid != null) {
                    print('로그인 되어있음 홈으로');
                    return const HomePage();
                  } else {
                    print('회원가입하러');
                    return SignupPage(uid: user.data!.uid);
                  }
                });
              }
            },
          );
        } else {
          print('아직 로그인 안됨');
          return WelcomePage();
        }
      },
    );
  }
}
