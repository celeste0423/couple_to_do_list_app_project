import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/helper/show_alert_dialog.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:couple_to_do_list_app/widgets/basic_container.dart';
import 'package:couple_to_do_list_app/widgets/custom_divider.dart';
import 'package:couple_to_do_list_app/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:launch_review/launch_review.dart';
import 'package:share_plus/share_plus.dart';

String playstoreurl = '';

class SettingsPage extends StatefulWidget {
  SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  PreferredSizeWidget customAppBar() {
    return AppBar(
      backgroundColor: CustomColors.backgroundLightGrey,
      title: titleText('설정'),
      leading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: CustomColors.mainPink,
        ),
      ),
    );
  }

  Widget accountListTile() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.7),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(1.5, 1.5), // Offset(수평, 수직)
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          leading: Image.asset(
            'assets/icons/google.png',
            width: 40,
          ),
          title: Text(
            '구글 계정',
            style: TextStyle(fontSize: 25),
          ),
          subtitle: Text(Get.find<AuthController>().user.value.email ?? '',
              style:
                  TextStyle(color: CustomColors.lightGreyText, fontSize: 20)),
        ),
      ),
    );
  }

  Widget secondContainer(double imagewidth) {
    return basicContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ListTile(
            leading: Image.asset(
              'assets/icons/bell.png',
              width: imagewidth,
            ),
            title: Text(
              '공지사항',
              style: TextStyle(fontSize: 25),
            ),
            trailing: Icon(
              Icons.navigate_next,
              color: CustomColors.lightGreyText,
            ),
            onTap: () {},
          ),
          Divider(
            thickness: 1,
            color: CustomColors.grey,
          ),
          ListTile(
            leading: Image.asset(
              'assets/icons/megaphone.png',
              width: imagewidth,
            ),
            title: Text(
              '알림',
              style: TextStyle(fontSize: 25),
            ),
            trailing: Icon(
              Icons.navigate_next,
              color: CustomColors.lightGreyText,
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget thirdContainer(double imagewidth) {
    return basicContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ListTile(
            leading: Image.asset(
              'assets/icons/sharing.png',
              width: imagewidth,
            ),
            title: Text(
              '앱 공유',
              style: TextStyle(fontSize: 25),
            ),
            trailing: Icon(
              Icons.navigate_next,
              color: CustomColors.lightGreyText,
            ),
            onTap: () async {
              //Todo: FlutterShare package ios installation 필요 https://pub.dev/packages/share_plus
              //Todo : appstore link 바꿔놓기
              await Share.share(
                  '버꿍리스트 \n https://play.google.com/store/apps/details?id=com.dentkim.balancegame&hl=ko',
                  subject: '버꿍리스트');
            },
          ),
          Divider(
            thickness: 1,
            color: CustomColors.grey,
          ),
          ListTile(
            leading: Image.asset(
              'assets/icons/feedback.png',
              width: imagewidth,
            ),
            title: Text(
              '후기 남기기',
              style: TextStyle(fontSize: 25),
            ),
            trailing: Icon(
              Icons.navigate_next,
              color: CustomColors.lightGreyText,
            ),
            onTap: () {
              //Todo: LauchReview package ios install 할때 할것 https://pub.dev/packages/launch_review
              LaunchReview.launch();
            },
          ),
          Divider(
            thickness: 1,
            color: CustomColors.grey,
          ),
          ListTile(
            leading: Image.asset(
              'assets/icons/info.png',
              width: imagewidth,
            ),
            title: Text(
              '버전정보',
              style: TextStyle(fontSize: 25),
            ),
            trailing: Icon(
              Icons.navigate_next,
              color: CustomColors.lightGreyText,
            ),
            //Todo: 버전정보 1.0.0 수정하기
            onTap: () {
              openAlertDialog(title: '버전정보', content: 'ver 1.0.0');
            },
          ),
        ],
      ),
    );
  }

  Widget logoutListTile(double imagewidth) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.7),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(1.5, 1.5), // Offset(수평, 수직)
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: ListTile(
        leading: Image.asset(
          'assets/icons/logout.png',
          width: imagewidth,
        ),
        title: Text(
          '로그아웃',
          style: TextStyle(
            fontSize: 25,
            color: Colors.red,
          ),
        ),
        onTap: () {
          //Todo: 로그아웃 구현해야함
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double imagewidth = 35.0;
    return Scaffold(
      appBar: customAppBar(),
      body: Column(
        children: [
          customDivider(),
          Hero(tag: 'addButton', child: accountListTile()),
          secondContainer(imagewidth),
          thirdContainer(imagewidth),
          logoutListTile(imagewidth),
        ],
      ),
    );
  }
}
