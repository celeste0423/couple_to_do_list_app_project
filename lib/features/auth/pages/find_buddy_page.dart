import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/features/auth/pages/welcome_page.dart';
import 'package:couple_to_do_list_app/features/auth/repository/user_repository.dart';
import 'package:couple_to_do_list_app/features/auth/widgets/registration_stage.dart';
import 'package:couple_to_do_list_app/helper/show_alert_dialog.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:couple_to_do_list_app/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../widgets/main_button.dart';

//Todo: 친구 찾기 완료하면 authcontroller 없애야 하나

class FindBuddyPage extends StatefulWidget {
  FindBuddyPage({Key? key, required this.email}) : super(key: key);
  final String email;

  @override
  State<FindBuddyPage> createState() => _FindBuddyPageState();
}

class _FindBuddyPageState extends State<FindBuddyPage> {
  final AuthController authController = AuthController();
  TextEditingController emailController = TextEditingController();

  Widget _appBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            padding: EdgeInsets.only(left: 20),
            onPressed: () {
              //
              UserRepository.googleAccountDeletion();
              //만약 회원 가입 중간에 다시 되돌아갈 경우 구글 계정 다시 로그인하게 함
              Get.to(WelcomePage());
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 30,
              color: Colors.white,
            ),
          ),
          titleText('짝꿍 찾기'),
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
      height: MediaQuery.of(context).size.height *1/2 -MediaQuery.of(context).viewInsets.bottom *1/2,
      width: MediaQuery.of(context).size.width,
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
    return TextButton(
      onPressed: () {
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            useremail ?? '',
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
          SizedBox(width: 10),
          Icon(
            Icons.copy,
            size: 30,
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget _inviteButton() {
    return TextButton(onPressed: () {}, child: Text('초대 메시지 보내기'));
  }

  Widget _floatingContainer() {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Container(
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
        _startButton(),
        Positioned(bottom: -100,
            child: _myEmail())
      ],
    );
  }
 Widget _myEmail(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '내 이메일',
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
        _emailCopyButton(),
        // _inviteButton(),
      ],
    );
 }
  Widget _emailTextField() {
    return TextField(
      controller: emailController,
      decoration: InputDecoration(
        hintText: 'ex) Bukkung@google.com',
        prefixIcon: Icon(Icons.email),
        suffixIcon: IconButton(
          icon: Icon(Icons.clear, size: 20),
          onPressed: () {
            return emailController.clear();
          },
        ),
      ),
    );
  }

  Widget _startButton() {
    return Positioned(
      bottom: 0,
      right: MediaQuery.of(context).size.width * 1 / 2 - 75,
      child: mainButton(
        '시작하기',
        () async {
          if (await authController.groupCreation(
                  widget.email, emailController.text) ==
              false) {
            showAlertDialog(context: context, message: '올바른 메일주소를 입력해주세요');
          }
          ;
        },
        150,
        CustomColors.lightPink,
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
        body: SafeArea(
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
              Align(alignment: Alignment.bottomCenter, child: _backgroundBottom()),
              Align(alignment: Alignment.center, child: _floatingContainer()),
            ],
          ),
        ),
      ),
    );
  }
}
