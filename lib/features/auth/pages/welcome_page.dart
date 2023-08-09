import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:couple_to_do_list_app/constants/constants.dart';
import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/features/auth/widgets/apple_login_button.dart';
import 'package:couple_to_do_list_app/features/auth/widgets/google_login_button.dart';
import 'package:couple_to_do_list_app/features/auth/widgets/kakao_login_button.dart';
import 'package:couple_to_do_list_app/helper/local_notification.dart';
import 'package:couple_to_do_list_app/helper/open_alert_dialog.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:couple_to_do_list_app/widgets/text/BkText.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  PackageInfo? packageInfo;

  @override
  void initState() {
    super.initState();
    print(AuthController.to.user.value.email);
  }

  Future<String> getVersionInfo() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Widget _subTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Image.asset('assets/images/title_vertical.png'),
        ),
        RotatedBox(
          quarterTurns: 45,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 208, top: 30),
                child: Divider(
                  thickness: 1,
                  color: Colors.white,
                ),
              ),
              BkText(
                '내 짝꿍과 ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                ),
              ),
              SizedBox(height: 20),
              BkText(
                '이루고 싶은 버킷리스트',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoText() {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
              color: CustomColors.darkGrey,
              fontSize: 15,
            ),
            children: [
              TextSpan(
                text: '이용약관 ',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 15),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    Uri uri = Uri.parse(Constants.serviceTermsNotionUrl);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    } else {
                      openAlertDialog(title: '오류 발생');
                    }
                  },
              ),
              TextSpan(text: '및 '),
              TextSpan(
                text: '공지사항',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 15),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    Uri uri = Uri.parse(Constants.noticeNotionUrl);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    } else {
                      openAlertDialog(title: '오류 발생');
                    }
                  },
              ),
              TextSpan(text: '을 클릭하여 확인하세요'),
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        FutureBuilder<String>(
          future: getVersionInfo(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.none ||
                snapshot.connectionState == ConnectionState.waiting) {
              // Future가 생성되지 않았거나 실행 중인 경우 로딩 상태를 표시할 수 있습니다.
              return CircularProgressIndicator(); // 로딩 스피너 또는 다른 로딩 UI
            } else if (snapshot.connectionState == ConnectionState.done) {
              // Future가 완료된 경우 데이터를 가져와서 표시합니다.
              if (snapshot.hasData) {
                final version = snapshot.data!;
                return Text(
                  'v $version',
                  style: TextStyle(
                    color: CustomColors.darkGrey,
                    fontSize: 10,
                  ),
                );
              } else {
                // Future가 데이터를 가져오지 못한 경우에 대한 처리를 할 수 있습니다.
                return Text('Error: Failed to get version information');
              }
            } else {
              // active 상태는 실제로 FutureBuilder에서 거의 사용되지 않습니다.
              // 따라서 필요에 따라 처리를 추가할 수 있습니다.
              return Text('Unknown error');
            }
          },
        ),
      ],
    );
  }

  Widget _buttomLoginTab(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: Get.width,
      height: 320,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(45),
          topLeft: Radius.circular(45),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'SNS 로그인',
            style: TextStyle(
              color: CustomColors.darkGrey,
              fontSize: 12,
            ),
          ),
          KakaoLoginButton(),
          GoogleLoginButton(),
          AppleLoginButton(),
          SizedBox(height: 5),
          _customLoginButton(),
          SizedBox(height: 10),
          _infoText(),
        ],
      ),
    );
  }

  Widget _customLoginButton() {
    return GestureDetector(
      onTap: () {
        Get.dialog(_registerDialog());
      },
      child: Text(
        '게스트로 로그인',
        style: TextStyle(
          fontSize: 15,
          color: CustomColors.greyText,
        ),
      ),
    );
  }

  Widget _registerDialog() {
    return Dialog(
      child: Container(
        height: 260,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: '이메일'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: '비밀번호'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                AuthController.loginType = 'guest';
                AuthController.to.signInWithEmailAndPassword(
                  emailController.text,
                  passwordController.text,
                );
                Get.back();
              },
              child: Text('회원가입 또는 로그인'),
            ),
            SizedBox(height: 10),
            Text(
              '(주의) 이메일과 비밀번호를 분실하신 경우에는 계정을 새로 만드셔야 합니다.',
              style: TextStyle(
                color: CustomColors.greyText,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('웰컴페이지야(wel page)');
    LocalNotification.init();
    return Scaffold(
      backgroundColor: CustomColors.mainPink,
      body: ColorfulSafeArea(
        bottomColor: Colors.white,
        child: Column(
          children: [
            SizedBox(height: 20),
            Expanded(flex: 3, child: _subTitle()),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Image.asset('assets/images/ggomool.png'),
              ),
            ),
            SizedBox(height: 30),
            _buttomLoginTab(context),
          ],
        ),
      ),
    );
  }
}
