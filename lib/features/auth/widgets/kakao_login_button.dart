// import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
// import 'package:couple_to_do_list_app/features/auth/controller/login.dart';
// import 'package:couple_to_do_list_app/features/auth/controller/viewmodel.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class KakaoLoginButton extends StatelessWidget {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final AuthController authController = AuthController();
//   final kakaoviewModel = MainViewModel(KakaoLogin());
//
//   String? userid;
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () async {
//         print('카카오버튼눌렀음');
//
//         await kakaoviewModel.login();
//         final OAuthCredential credential =
//
//
//         //이미 로그인 됐을 때
//         if (kakaoviewModel.isLogined) {
//           userid = kakaoviewModel.user!.id.toString();
//           authController.changeRegisterProgressIndex('userRegistration');
//         }
//       },
//       child: Image.asset(
//         'assets/images/kakao_login_medium_narrow.png',
//       ),
//     );
//   }
// }
//
//
//
//
