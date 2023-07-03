import 'package:couple_to_do_list_app/constants/constants.dart';
import 'package:couple_to_do_list_app/features/auth/widgets/google_login_button.dart';
import 'package:couple_to_do_list_app/features/auth/widgets/kakao_login_button.dart';
import 'package:couple_to_do_list_app/helper/local_notification.dart';
import 'package:couple_to_do_list_app/helper/show_alert_dialog.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class WelcomePage extends StatefulWidget {
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  PackageInfo? packageInfo;

  @override
  void initState() {
    super.initState();
    initPackageInfo();
  }

  Future<void> initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      packageInfo = info;
    });
  }

  void _launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _subTitle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: Get.width,
      child: const Text(
        '내 짝꿍과 \n 이루고 싶은 버킷리스트',
        style: TextStyle(
          color: Colors.white,
          fontSize: 30,
        ),
      ),
    );
  }

  Widget _appTitle() {
    return Text(
      '버꿍리스트',
      style: TextStyle(
        color: Colors.black,
        fontSize: 65,
      ),
    );
  }

  Widget _infoText() {
    String version = packageInfo!.version;
    return Column(
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
                text: '이용약관 ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
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
                ),
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
              TextSpan(text: '은 눌러서 확인하세요'),
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          'v $version',
          style: TextStyle(
            color: CustomColors.darkGrey,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget _buttomLoginTab(BuildContext context) {
    return Container(
      width: Get.width,
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
            KakaoLoginButton(),
            GoogleLoginButton(),
            _infoText(),
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
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            Expanded(flex: 1, child: _subTitle()),
            Expanded(flex: 1, child: _appTitle()),
            Expanded(flex: 4, child: Image.asset('assets/images/ggomool.png')),
            Expanded(flex: 3, child: _buttomLoginTab(context)),
          ],
        ),
      ),
    );
  }
}
