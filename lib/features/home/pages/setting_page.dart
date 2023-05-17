import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:couple_to_do_list_app/widgets/basic_container.dart';
import 'package:couple_to_do_list_app/widgets/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int imagewidth = 10;

  accountListTile() {
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
        borderRadius: BorderRadius.all(Radius.circular(20))
        ,
      ),
      child: ListTile(
        leading: Image.asset('assets/icons/google.png/', width: 10,),
        title: Text('구글 계정', style: TextStyle(fontSize: 25),),
        subtitle: Text(Get
            .find<AuthController>()
            .user
            .value
            .email ?? '',
            style: TextStyle(color: CustomColors.lightGreyText, fontSize: 20)),
      ),
    );
  }

  Widget logoutListTile(){
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
        borderRadius: BorderRadius.all(Radius.circular(20))
        ,
      ),
      child: ListTile(
        leading: Image.asset('assets/icons/logout.png/', width: 10,),
        title: Text('로그아웃', style: TextStyle(fontSize: 25, color: Colors.red),),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.backgroundLightGrey,
        title: Text('설정'),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: CustomColors.mainPink,
          ),
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //
        //     },
        //     icon: Image.asset(
        //       'assets/icons/setting.png',
        //       color: Colors.white.withOpacity(0.7),
        //       colorBlendMode: BlendMode.modulate,
        //     ),
        //   ),
        // ],
      ),
      body: Column(
        children: [
          customDivider(),
          accountListTile(
          ),
          basicContainer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ListTile(
                  leading: Image.asset('assets/icons/bell.png/', width: 10,),
                  title: Text('공지사항', style: TextStyle(fontSize: 25),),
                  trailing: Icon(Icons.navigate_next, color: CustomColors.grey,),
                ),
                Divider(
                  thickness: 1,
                  color: CustomColors.grey,
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/icons/megaphone.png/', width: 10,),
                  title: Text('알림', style: TextStyle(fontSize: 25),),
                  trailing: Icon(Icons.navigate_next, color: CustomColors.grey,),
                ),
              ],
            ),
          ),
          basicContainer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ListTile(
                  leading: Image.asset('assets/icons/sharing.png/', width: 10,),
                  title: Text('앱 공유', style: TextStyle(fontSize: 25),),
                  trailing: Icon(Icons.navigate_next, color: CustomColors.grey,),
                ),
                Divider(
                  thickness: 1,
                  color: CustomColors.grey,
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/icons/feedback.png/', width: 10,),
                  title: Text('후기 남기기', style: TextStyle(fontSize: 25),),
                  trailing: Icon(Icons.navigate_next, color: CustomColors.grey,),
                ),
                Divider(
                  thickness: 1,
                  color: CustomColors.grey,
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/icons/info.png/', width: 10,),
                  title: Text('버전정보', style: TextStyle(fontSize: 25),),
                  trailing: Icon(Icons.navigate_next, color: CustomColors.grey,),
                ),
              ],
            ),
          ),
          logoutListTile(),
        ],
      ),
    );
  }
}
