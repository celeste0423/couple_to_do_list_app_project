import 'package:couple_to_do_list_app/features/auth/pages/user_registration.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColors.mainPink,
        body: Column(
          children: [
            SizedBox(height: 20,),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                child: const Text(
                  '내 짝꿍과 \n 이루고 싶은 버킷리스트',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            const Expanded(
              flex: 1,
              child: Text(
                '버꿍리스트',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 65,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Image.asset('assets/images/ggomool.png'),
            ),
            Expanded(
              flex: 3,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(45),
                    topLeft: Radius.circular(45),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'SNS 로그인',
                        style: TextStyle(
                          color: CustomColors.darkGrey,
                          fontSize: 25,
                        ),
                      ),
                      GestureDetector(
                          onTap: (){
                            print('로그인 계시-일단은 다음페이지로');
                          Get.to(User_registrationPage());
                          },
                          child: Image.asset('assets/images/kakao_login_medium_narrow.png')),
                      Column(
                        children: [
                          RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                    color: CustomColors.darkGrey,
                                    fontFamily: 'Yoonwoo',
                                    fontSize: 20,
                                  ),
                                  children: [
                                TextSpan(text: '회원가입 시 '),
                                TextSpan(
                                    text: '약관 ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Get.snackbar(
                                          '약관 올라가게',
                                          'this is a snackbar',
                                        );
                                      }),
                                TextSpan(text: '및 '),
                                TextSpan(
                                    text: '공지사항',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Get.snackbar(
                                          '공지사항 올라가게',
                                          'this is a snackbar',
                                        );
                                      }),
                                TextSpan(text: '은 눌러서 확인하세요'),
                              ])),
                          SizedBox(height: 5,),
                          Text(
                            'v 1.0.0',
                            style: TextStyle(
                              color: CustomColors.darkGrey,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
