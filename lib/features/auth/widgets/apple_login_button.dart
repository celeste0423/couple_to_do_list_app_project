import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';

class AppleLoginButton extends StatelessWidget {
  final AuthController authController = AuthController();

  String? userid;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        //Todo: 애플 로그인 구현

        //로그인 타입 설정
        AuthController.loginType = 'apple';
      },
      child: Stack(
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xFF000000),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(),
            ),
            child: Center(
              child: Text(
                'Apple로 로그인',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            left: 5,
            top: 5,
            child: Image.asset(
              'assets/icons/apple.png',
              height: 40,
            ),
          ),
        ],
      ),
    );
  }
}
