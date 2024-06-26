import 'package:couple_to_do_list_app/src/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/src/features/setting/controller/setting_page_controller.dart';
import 'package:couple_to_do_list_app/src/features/setting/pages/auth_delete_page.dart';
import 'package:couple_to_do_list_app/src/features/setting/pages/notification_setting_page.dart';
import 'package:couple_to_do_list_app/src/helper/analytics.dart';
import 'package:couple_to_do_list_app/src/helper/open_alert_dialog.dart';
import 'package:couple_to_do_list_app/src/utils/custom_color.dart';
import 'package:couple_to_do_list_app/src/widgets/basic_container.dart';
import 'package:couple_to_do_list_app/src/widgets/custom_divider.dart';
import 'package:couple_to_do_list_app/src/widgets/text/PcText.dart';
import 'package:couple_to_do_list_app/src/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';

class SettingPage extends GetView<SettingPageController> {
  const SettingPage({super.key});

  PreferredSizeWidget customAppBar() {
    return AppBar(
      backgroundColor: CustomColors.backgroundLightGrey,
      title: TitleText(text: '설정'),
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
        child: Obx(() {
          switch (controller.loginType.value) {
            case 'google':
              return loginTypeTile('google', '구글');
            case 'kakao':
              return loginTypeTile('kakaos', '카카오');
            case 'apple':
              return loginTypeTile('apple', '애플');
            case 'guest':
              return loginTypeTile('ggomool', '게스트');
            default:
              return loginTypeTile('ggomool', '버꿍리스트');
          }
        }),
      ),
    );
  }

  Widget loginTypeTile(String loginType, String krLoginType) {
    return ListTile(
      leading: Image.asset(
        'assets/icons/$loginType.png',
        width: 40,
      ),
      title: Text(
        '$krLoginType 계정',
        style: TextStyle(fontSize: 20),
      ),
      subtitle: PcText(
        AuthController.to.user.value.email ?? '',
        style: TextStyle(
          color: CustomColors.lightGreyText,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _notificationSetting(double imagewidth) {
    return BasicContainer(
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
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              controller.openNotice();
            },
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
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              // openAlertDialog(title: '알림 기능 구현 예정입니다.');
              Get.to(() => NotificationSettingPage());
            },
          ),
        ],
      ),
    );
  }

  Widget _appSetting(double imagewidth, context) {
    return BasicContainer(
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
              style: TextStyle(fontSize: 20),
            ),
            onTap: () async {
              final box = context.findRenderObject() as RenderBox?;
              await Share.share(
                '\n플레이 스토어:\nhttps://play.google.com/store/apps/details?id=com.teambukkung.bukkunglist\n앱스토어:\nhttps://apps.apple.com/kr/app/%EB%B2%84%EA%BF%8D%EB%A6%AC%EC%8A%A4%ED%8A%B8-%EC%BB%A4%ED%94%8C-%EB%B2%84%ED%82%B7%EB%A6%AC%EC%8A%A4%ED%8A%B8/id6451405746',
                subject: '버꿍리스트',
                sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
              );
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
              style: TextStyle(fontSize: 20),
            ),
            onTap: () async {
              final InAppReview inAppReview = InAppReview.instance;

              if (await inAppReview.isAvailable()) {
                inAppReview.requestReview();
              }
              //Todo: LauchReview package ios install 할때 할것 https://pub.dev/packages/launch_review
              // LaunchReview.launch();
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
              style: TextStyle(fontSize: 20),
            ),
            onTap: () async {
              PackageInfo packageInfo = await PackageInfo.fromPlatform();

              // String appName = packageInfo.appName;
              // String packageName = packageInfo.packageName;
              String version = packageInfo.version;
              String buildNumber = packageInfo.buildNumber;
              openAlertDialog(
                title: '버전정보',
                content: '버전: $version\n빌드번호: $buildNumber',
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _logoutListTile(double imagewidth) {
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
      child: Column(
        children: [
          ListTile(
            leading: Image.asset(
              'assets/icons/logout.png',
              width: imagewidth,
            ),
            title: Text(
              '로그아웃',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            onTap: () {
              openAlertDialog(
                title: '로그아웃 하시겠습니까?',
                btnText: '로그아웃',
                secondButtonText: '취소',
                mainfunction: () async {
                  await controller.signOut();
                  //todo: get.back 이거 왜 2개 있는거고 애초에 갯백이 필요한가? root에 있는 streambuilder있는데... screeen stack을 없애려고 하는건가
                  Get.back();
                  Get.back();
                },
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Divider(
              thickness: 1,
              color: CustomColors.grey,
            ),
          ),
          GestureDetector(
            child: Container(
              height: 50,
              color: Colors.transparent,
              width: double.infinity,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 70),
                  child: Text(
                    '탈퇴하기',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),
            onTap: () {
              Analytics().logEvent('account_deletion', null);
              Get.to(() => AuthDeletePage());
            },
          ),
        ],
      ),
    );
  }

  // Widget _authDeleteTile(double imagewidth) {
  //   return Container(
  //     margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey.withOpacity(0.7),
  //           spreadRadius: 1,
  //           blurRadius: 3,
  //           offset: Offset(1.5, 1.5), // Offset(수평, 수직)
  //         ),
  //       ],
  //       borderRadius: BorderRadius.all(Radius.circular(20)),
  //     ),
  //     child: ListTile(
  //       leading: Image.asset(
  //         'assets/icons/logout.png',
  //         width: imagewidth,
  //       ),
  //       title: Text(
  //         '탈퇴하기',
  //         style: TextStyle(
  //           fontSize: 20,
  //           color: Colors.red,
  //         ),
  //       ),
  //       onTap: () {
  //         Get.to(() => AuthDeletePage());
  //       },
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    Get.put(SettingPageController());
    double imageWidth = 33.0;
    return Scaffold(
      appBar: customAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomDivider(),
            Hero(tag: 'addButton', child: accountListTile()),
            _notificationSetting(imageWidth),
            _appSetting(imageWidth, context),
            _logoutListTile(imageWidth),
          ],
        ),
      ),
    );
  }
}
