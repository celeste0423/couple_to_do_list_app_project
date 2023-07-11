import 'package:couple_to_do_list_app/features/home/controller/my_page_controller.dart';
import 'package:couple_to_do_list_app/features/setting/pages/setting_page.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:couple_to_do_list_app/widgets/png_icons.dart';
import 'package:couple_to_do_list_app/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  Widget _myPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Stack(
        children: [
          _cardBackground(),
          Column(
            children: [
              _nickname(context),
              _achievement(),
              _levelCircularBar(),
              _chatButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cardBackground() {
    return Column(
      children: [
        Container(
          height: 220,
          decoration: BoxDecoration(
            color: CustomColors.mainPink,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30),
            ),
          ),
        ),
        Flexible(
          child: Container(
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
          ),
        ),
        SizedBox(height: 90),
      ],
    );
  }

  Widget _nickname(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        top: 30,
        bottom: 20,
        right: 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Align(
              alignment: Alignment.center,
              child: FractionallySizedBox(
                widthFactor: 0.8,
                heightFactor: 0.8,
                child: Image.asset(
                  'assets/images/ggomool.png',
                ),
              ),
            ),
          ),
          SizedBox(width: 20),
          SizedBox(
            height: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Obx(
                  () => controller.isChangeNickname.value
                      ? SizedBox(
                          width: 250,
                          height: 60,
                          child: TextField(
                            maxLength: 10,
                            autofocus: true,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            keyboardType: TextInputType.text,
                            controller: controller.nicknameController,
                            cursorColor: Colors.black.withOpacity(0.5),
                            style: TextStyle(
                              fontSize: 27,
                              fontFamily: 'Pyeongchang',
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: '수정할 닉네임을 입력하세요',
                              hintStyle: TextStyle(
                                fontSize: 27,
                                fontFamily: 'Pyeongchang',
                              ),
                              counterText: '',
                              suffixIcon: IconButton(
                                icon: Icon(Icons.save, size: 25),
                                onPressed: () {
                                  controller.changeNickname();
                                },
                              ),
                            ),
                          ),
                        )
                      : SizedBox(
                          width: 250,
                          height: 60,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: controller.myNickname.value,
                                    style: TextStyle(
                                      fontFamily: 'Pyeongchang',
                                      fontSize: 30,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' 님 반갑습니다',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                ),
                GestureDetector(
                  onTap: () {
                    controller.changeNicknameStart();
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.edit_outlined,
                            size: 20,
                            color: Colors.white,
                          ),
                          Text(
                            '닉네임 수정하기',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        color: Colors.white,
                        width: 105,
                        height: 1,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Obx(
                  () => GestureDetector(
                    onTap: () {
                      controller.setDayMet(context);
                    },
                    child: SizedBox(
                      width: 250,
                      child: controller.isDayMet.value
                          ? FittedBox(
                              fit: BoxFit.scaleDown,
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: controller.buddyNickname.value,
                                      style: TextStyle(
                                        fontFamily: 'Pyeongchang',
                                        fontSize: 20,
                                        color: CustomColors.blackText,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' 님과 함께한 지 ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w200,
                                        fontSize: 18,
                                        color: CustomColors.blackText,
                                      ),
                                    ),
                                    TextSpan(
                                      text: controller.togetherDate.value
                                          .toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: CustomColors.blackText,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '일째',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: CustomColors.blackText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Text(
                              '여기를 눌러 만난 날짜를 설정하세요',
                              style: TextStyle(
                                fontSize: 15,
                                color: CustomColors.blackText,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        controller.isChangeNickname(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: _appBar(),
        body: _myPage(context),
      ),
    );
  }
}
