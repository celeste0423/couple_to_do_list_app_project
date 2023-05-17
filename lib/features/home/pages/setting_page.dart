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

  accountListTile(){
  return ListTile(
    tileColor: Colors.white,
    leading:Icon(Icons.account_circle),
    title: Text('구글 계정', style: TextStyle(fontSize: 25),),
    subtitle: Text(Get.find<AuthController>().user.value.email ?? '', style: TextStyle(color: CustomColors.lightGreyText, fontSize: 20)),

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
          Expanded(child: basicContainer()),
        ],
      ),
    );
  }
}
