import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:couple_to_do_list_app/src/features/auth/controller/find_buddy_page_controller.dart';
import 'package:couple_to_do_list_app/src/features/auth/widgets/registration_stage.dart';
import 'package:couple_to_do_list_app/src/utils/custom_color.dart';
import 'package:couple_to_do_list_app/src/widgets/text/PcText.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';

import '../../../widgets/main_button.dart';

class FindBuddyPage extends GetView<FindBuddyPageController> {
  String email;
  FindBuddyPage({super.key, required this.email});

  Widget _appBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 50,
          ),
          // IconButton(
          //   padding: EdgeInsets.only(left: 20),
          //   onPressed: () {
          //     UserRepository.googleAccountDeletion();
          //     //만약 회원 가입 중간에 다시 되돌아갈 경우 구글 계정 다시 로그인하게 함
          //     Get.to(() => WelcomePage());
          //   },
          //   icon: Icon(
          //     Icons.arrow_back_ios,
          //     size: 30,
          //     color: Colors.white,
          //   ),
          // ),
          PcText(
            '짝꿍 찾기',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
            ),
          ),
          SizedBox(
            width: 50,
          ),
        ],
      ),
    );
  }

  Widget _backgroundHandShakeImage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Image.asset('assets/images/handshake.png'),
    );
  }

  Widget _backgroundBottom() {
    return Container(
      height: Get.height * 1 / 2 - 50,
      width: Get.width,
      decoration: const BoxDecoration(
        color: CustomColors.redbrown,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(45),
          topLeft: Radius.circular(45),
        ),
      ),
    );
  }

  Widget _emailCopyButton() {
    final String useremail = email;
    // print(useremail);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 15),
        useremail.length <= 24
            ? SizedBox(
                height: 30,
                child: Text(
                  useremail,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              )
            : SizedBox(
                width: Get.width - 65,
                height: 30,
                child: Marquee(
                  text: useremail,
                  pauseAfterRound: Duration(seconds: 1),
                  style: TextStyle(fontSize: 20, color: Colors.white),
                  velocity: 25,
                  scrollAxis: Axis.horizontal,
                  blankSpace: 20.0,
                ),
              ),
        SizedBox(width: 10),
        Icon(
          Icons.copy,
          size: 30,
          color: Colors.white,
        ),
        SizedBox(width: 10),
      ],
    );
  }

  Widget _floatingContainer() {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          height: 540,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 135),
            height: 270,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                controller.emailFocusNode.hasFocus
                    ? SizedBox()
                    : Image.asset(
                        'assets/images/email.png',
                        color: CustomColors.grey,
                        height: 70,
                      ),
                RichText(
                  text: TextSpan(
                    children: const [
                      TextSpan(
                        text: '짝꿍의 ',
                        style:
                            TextStyle(fontSize: 20, color: CustomColors.grey),
                      ),
                      TextSpan(
                        text: '이메일',
                        style: TextStyle(
                          fontSize: 20,
                          color: CustomColors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '을 입력하세요',
                        style:
                            TextStyle(fontSize: 20, color: CustomColors.grey),
                      ),
                    ],
                  ),
                ),
                Text(
                  '주의 : 한 사람만 이메일 찾기를 눌러서 진행해주세요 \n 만약 상대방이 찾기를 눌렀음에도 이 페이지에서 넘어가지 않으면\n 앱을 껐다 켜주세요',
                  style: TextStyle(
                    fontSize: 9,
                  ),
                ),
                _emailTextField(),
                _soloGroupButton(),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
        Positioned(bottom: 135 - 25, child: _startButton()),
        Positioned(bottom: 0, child: _emailBox()),
      ],
    );
  }

  Widget _emailTextField() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: TextField(
        controller: controller.emailController,
        focusNode: controller.emailFocusNode,
        style: TextStyle(
          fontSize: 13,
          fontFamily: 'Pyeongchang',
        ),
        decoration: InputDecoration(
          hintText: 'ex) Bukkung@google.com',
          hintStyle: TextStyle(
            fontSize: 13,
            fontFamily: 'Pyeongchang',
          ),
          prefixIcon: Icon(
            Icons.email,
            color: CustomColors.greyText,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.clear,
              size: 20,
              color: CustomColors.greyText,
            ),
            onPressed: () {
              return controller.emailController.clear();
            },
          ),
        ),
      ),
    );
  }

  Widget _soloGroupButton() {
    return GestureDetector(
      onTap: () async {
        controller.soloGroupButton(email);
      },
      child: Text(
        '나중에 짝꿍 추가하기',
        style: TextStyle(decoration: TextDecoration.underline),
      ),
    );
  }

  Widget _startButton() {
    return MainButton(
      buttonText: '찾기',
      onTap: () async {
        controller.startButton(email);
      },
      width: 150,
      buttonColor: CustomColors.mainPink,
    );
  }

  Widget _emailBox() {
    final String userEmail = email;
    return GestureDetector(
      onTap: () {
        Clipboard.setData(
          ClipboardData(text: userEmail),
        ).then(
          (_) {
            Get.snackbar(
              '이메일',
              '복사 완료',
              icon: Icon(Icons.email),
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.white,
            );
          },
        );
      },
      child: SizedBox(
        width: Get.width,
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '내 이메일',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            _emailCopyButton(),
            // _inviteButton(),
          ],
        ),
      ),
    );
  }

  // Widget _refreshButton() {
  //   return AnimatedOpacity(
  //     //키보드 올라온 것에 따른 투명도 조절
  //     opacity: MediaQuery.of(context).viewInsets.bottom == 0 ? 1.0 : 0.0,
  //     duration: Duration(milliseconds: 200),
  //     child: FloatingActionButton(
  //       elevation: 0,
  //       onPressed: () async {
  //         //  print('리프레시 버튼 이메일${widget.email}');
  //         //   print('그룹 찾기${await authController.getGroupModel(widget.email)}');
  //         GroupModel? group = await authController.getGroupModel(widget.email);
  //         if (group != null) {
  //           authController.group(group);
  //
  //           FirebaseAuth.instance.reactive;
  //           Get.off(() => App());
  //         } else {
  //           // print('그룹아이디 못찾음');
  //         }
  //       },
  //       child: Icon(
  //         Icons.refresh,
  //         color: CustomColors.mainPink,
  //         size: 35,
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    Get.put(FindBuddyPageController());
    return KeyboardDismissOnTap(
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        backgroundColor: CustomColors.mainPink,
        body: ColorfulSafeArea(
          bottomColor: CustomColors.redbrown,
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _appBar(),
                  RegistrationStage(2),
                  SizedBox(height: 15),
                  _backgroundHandShakeImage(),
                ],
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: _backgroundBottom()),
              Align(
                alignment: Alignment.center,
                child: _floatingContainer(),
              ),
            ],
          ),
        ),
        // floatingActionButton: _refreshButton(),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
