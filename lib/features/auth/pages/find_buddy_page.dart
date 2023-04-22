import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/features/auth/pages/wait_buddy_page.dart';
import 'package:couple_to_do_list_app/features/auth/widgets/registration_stage.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:couple_to_do_list_app/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class FindBuddyPage extends StatefulWidget {
  FindBuddyPage({Key? key}) : super(key: key);

  @override
  State<FindBuddyPage> createState() => _FindBuddyPageState();
}

class _FindBuddyPageState extends State<FindBuddyPage> {
  final AuthController authController = AuthController();

  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColors.mainPink,
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                titleText('짝꿍 찾기'),
                SizedBox(
                  height: 15,
                ),
                RegistrationStage(2),
                SizedBox(
                  height: 15,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Image.asset('assets/images/handshake.png')),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: CustomColors.redbrown,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(45),
                        topLeft: Radius.circular(45),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              authController.changeRegisterProgressIndex(3);
                            },
                            child: Text(
                              '임시 버튼',
                              style: TextStyle(color: Colors.red),
                            )),
                        Text(
                          '내 이메일',
                          style: TextStyle(fontSize: 30, color: Colors.white),
                        ),
                        TextButton(
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: 'ddosy99@naver.com'),
                            ).then(
                              (_) {
                                Get.snackbar('이메일', '복사 완료',
                                    icon: Icon(Icons.email),
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.white);
                              },
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'ddosy99@naver.com',
                                style: TextStyle(
                                    fontSize: 30, color: Colors.white),
                              ),
                              SizedBox(width: 10),
                              Icon(
                                Icons.copy,
                                size: 30,
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                        ),
                        SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.all(20),
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset(
                      'assets/images/email.png',
                      color: CustomColors.grey,
                      height: 70,
                    ),
                    Text(
                      '짝꿍의 이메일을 입력하세요',
                      style: TextStyle(fontSize: 30, color: CustomColors.grey),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      height: 40,
                      child: TextField(
                        controller: email,
                        decoration: InputDecoration(
                          labelText: 'ddosy99@naver.com',
                          prefixIcon: Icon(Icons.email),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear, size: 20),
                            onPressed: () {
                              return email.clear();
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
