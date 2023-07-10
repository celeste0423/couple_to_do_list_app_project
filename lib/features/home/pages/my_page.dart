import 'package:couple_to_do_list_app/features/home/controller/my_page_controller.dart';
import 'package:couple_to_do_list_app/features/setting/pages/setting_page.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:couple_to_do_list_app/widgets/png_icons.dart';
import 'package:couple_to_do_list_app/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyPage extends GetView<MyPageController> {
  const MyPage({Key? key}) : super(key: key);

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: CustomColors.backgroundLightGrey,
      title: TitleText(text: '내 정보'),
      actions: [
        IconButton(
          onPressed: () {
            Get.to(() => SettingPage());
          },
          icon: PngIcon(
            iconName: 'setting',
            iconColor: Colors.white.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget _myPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Stack(
        children: [
          Column(
            children: [
              _nickname(),
              _achievement(),
              _levelCircularBar(),
              _chatButton(),
            ],
          ),
          _cardBackground(),
        ],
      ),
    );
  }

  Widget _cardBackground() {
    return Column(
      children: [
        Container(
          height: 180,
          decoration: BoxDecoration(
            color: CustomColors.mainPink,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30),
            ),
          ),
        ),
        Container(
          height: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                offset: Offset(0, 8),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _nickname() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.asset(
            'assets/images/ggomool.png',
            height: 50,
          ),
        ),
        Column(
          children: [
            RichText(
              text: TextSpan(text: controller.myNickname.value),
            ),
          ],
        ),
      ],
    );
  }

  Widget _achievement() {
    return Container();
  }

  Widget _levelCircularBar() {
    return Container();
  }

  Widget _chatButton() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(MyPageController());
    return Scaffold(
      appBar: _appBar(),
      body: _myPage(),
    );
  }
}
