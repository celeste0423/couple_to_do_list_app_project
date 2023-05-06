import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/features/auth/widgets/registration_stage.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:couple_to_do_list_app/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../widgets/main_button.dart';

class WaitBuddyPage extends StatelessWidget {
  WaitBuddyPage({Key? key}) : super(key: key);
  final AuthController authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.mainPink,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      padding: EdgeInsets.only(left: 20),
                      onPressed: () {
                        print('뒤로가기');
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    titleText('짝꿍을 기다리는 중'),
                    SizedBox(
                      width: 50,
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                RegistrationStage(3),
                SizedBox(
                  height: 15,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Image.asset('assets/images/handshake.png')),
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Container(
                    // padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(20),
                    height: 150,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(30.0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          '짝꿍에게 내 이메일을 알려주세요!',
                          style:
                              TextStyle(fontSize: 30, color: CustomColors.grey),
                        ),
                        TextButton(
                          onPressed: () {
                            Clipboard.setData(
                                    ClipboardData(text: 'ddosy99@naver.com'))
                                .then((_) {
                              Get.snackbar('이메일', '복사 완료',
                                  icon: Icon(Icons.email),
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.white);
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'ddosy99@naver.com',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontFamily: '',
                                  color: CustomColors.darkGrey,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.copy,
                                size: 30,
                                color: CustomColors.grey,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: Get.width * 1 / 2 - 75,
                    child: mainButton(
                      '새로고침',
                      () {
                        print('새로고침');
                      },
                      150,
                      CustomColors.redbrown,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
