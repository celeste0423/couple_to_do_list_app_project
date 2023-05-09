import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/features/auth/model/user_model.dart';
import 'package:couple_to_do_list_app/features/auth/pages/find_buddy_page.dart';
import 'package:couple_to_do_list_app/features/auth/pages/signup_page.dart';
import 'package:couple_to_do_list_app/features/auth/pages/welcome_page.dart';
import 'package:couple_to_do_list_app/features/home/pages/home_page.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Root extends StatelessWidget {
  final controller = AuthController();

  @override
  Widget build(BuildContext context) {
    //Todo: 사방팔방 if문들 로딩중에 들어갔다 나옴, 전부 로딩창으로 정리 필요
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext _, AsyncSnapshot<User?> user) {
        if (user.hasData) {
          return FutureBuilder<UserModel?>(
            future: controller.loginUser(user.data!.email ?? ''),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Obx(() {
                  print('로그인 정보 ${controller.user.toJson()}');
                  if (controller.user.value.uid == null) {
                    return Container(
                      color: Colors.white,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: CustomColors.mainPink,
                        ),
                      ),
                    );
                  } else {
                    if (controller.user.value.groupId != null) {
                      print('groupId 값이 존재함. HomePage로 이동합니다.');
                      return HomePage();
                    } else {
                      print('groupId 값이 아직 존재하지 않습니다. FindBuddyPage로 이동합니다.');
                      return FindBuddyPage(email: user.data!.email ?? '');
                    }
                  }
                });
              } else {
                print('신규 유저임(root)');
                return Obx(() {
                  print('유저정보(root) ${controller.user.value.uid}');
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
      },
    );
  }
}
//
//
// class Root extends StatelessWidget {
//   final controller = AuthController();
//   @override
//   Widget build(BuildContext context) {
//     print('그룹 id ${controller.user.value.groupId}');
//     return StreamBuilder(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (BuildContext _, AsyncSnapshot<User?> user) {
//         if (user.hasData) {
//           return FutureBuilder<UserModel?>(
//             //future로 리턴해준 값은 신규 유저여부 판별
//             future: controller.loginUser(user.data!.email ?? ''),
//             //Todo: 복귀유저가 로그인 해서 분명 snapshot에 데이터가 있을 텐데 findbuddy로 안감
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 print('로그인 정보 존재(root)');
//                 return FindBuddyPage(email: user.data!.email ?? '');
//               } else {
//                 //future가 완료되기 전 or 완료되었는데 정보가 없는 경우
//                 print('신규 유저임(root)${controller.user.value.email}');
//                 return Obx(() {
//                   print('유저정보(root) ${controller.user.value.uid}');
//                   //controller Rx를 구독하도록 수정
//                   if (controller.user.value.uid != null) {
//                     print('로그인 되어있음 버꿍찾기로(root)');
//                     return FindBuddyPage(email: user.data!.email ?? '');
//                   } else {
//                     print('회원가입하러(root)');
//                     return SignupPage(
//                       uid: user.data!.uid,
//                       email: user.data!.email ?? '',
//                     );
//                   }
//                 });
//               }
//             },
//           );
//         } else {
//           print('firebase가 null반환');
//           return WelcomePage();
//         }
//       },
//     );
//   }
// }
