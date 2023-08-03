import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/features/auth/widgets/registration_stage.dart';
import 'package:couple_to_do_list_app/features/home/pages/home_page.dart';
import 'package:couple_to_do_list_app/helper/open_alert_dialog.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:couple_to_do_list_app/widgets/text/PcText.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';

import '../../../widgets/main_button.dart';

class FindBuddyPage extends StatefulWidget {
  const FindBuddyPage({Key? key, required this.email}) : super(key: key);
  final String email;

  @override
  State<FindBuddyPage> createState() => _FindBuddyPageState();
}

class _FindBuddyPageState extends State<FindBuddyPage> {
  //Todo: auth
  final AuthController authController = AuthController.to;
  TextEditingController emailController = TextEditingController();

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
      height:
          Get.height * 1 / 2 - MediaQuery.of(context).viewInsets.bottom * 1 / 2,
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
    final String useremail = widget.email;
    print(useremail);
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
        Container(
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
                Image.asset(
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
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: _emailTextField(),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
        Positioned(bottom: 135 - 25, child: _startButton()),
        Positioned(bottom: 0, child: _myEmail()),
      ],
    );
  }

  Widget _myEmail() {
    final String useremail = widget.email;
    return GestureDetector(
      onTap: () {
        print('hi');
        Clipboard.setData(
          ClipboardData(text: useremail ?? ''),
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

  Widget _emailTextField() {
    return TextField(
      controller: emailController,
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
            return emailController.clear();
          },
        ),
      ),
    );
  }

  Widget _startButton() {
    return MainButton(
      buttonText: '찾기',
      onTap: () async {
        GroupIdStatus groupIdStatus = await authController.groupCreation(
            widget.email, emailController.text);
        if (groupIdStatus == GroupIdStatus.noData) {
          openAlertDialog(
              title: '올바른 메일주소를 입력하였는지,\n짝꿍이 회원가입을 완료 하였는지 확인해주세요.');
        } else if (groupIdStatus == GroupIdStatus.hasGroup) {
          openAlertDialog(title: '상대방이 이미 짝꿍이 있습니다.\n올바른 메일주소를 입력하였는지 확인해주세요.');
        } else {
          //BukkungListPageController initbinding을 여기다 해야 할 거 같음
          //InitBinding.additionalBinding();
          // InitBinding().refreshControllers();
          print("authcontroller에 들어갔나 ${AuthController.to.group.value.uid}");
          FirebaseAuth.instance.reactive;
          Get.off(() => HomePage());
        }
      },
      width: 150,
      buttonColor: CustomColors.mainPink,
    );
  }

  Widget _refreshButton() {
    return AnimatedOpacity(
      //키보드 올라온 것에 따른 투명도 조절
      opacity: MediaQuery.of(context).viewInsets.bottom == 0 ? 1.0 : 0.0,
      duration: Duration(milliseconds: 200),
      child: FloatingActionButton(
        elevation: 0,
        onPressed: () async {
          print('리프레시 버튼 이메일${widget.email}');
          print('그룹 찾기${await authController.findGroupId(widget.email)}');
          if (await authController.findGroupId(widget.email) ?? false) {
            print('그룹 찾음');
            //BukkungListPageController initbinding을 여기다 해야 할 거 같음
            //InitBinding.additionalBinding();
            // InitBinding().refreshControllers();
            Get.off(() => HomePage());
          }
        },
        child: Icon(
          Icons.refresh,
          color: CustomColors.mainPink,
          size: 35,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
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
              Align(alignment: Alignment.center, child: _floatingContainer()),
            ],
          ),
        ),
        floatingActionButton: _refreshButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
