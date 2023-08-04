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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 00),
      child: Stack(
        children: [
          _cardBackground(context),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
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

  Widget _cardBackground(context) {
    return Column(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: CustomColors.mainPink,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30),
            ),
          ),
        ),
        Container(
          //pink 부분이 200,
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom-200-kBottomNavigationBarHeight-120,
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
        SizedBox(height: 90),
      ],
    );
  }

  Widget _nickname(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        top: 10,
        bottom: 20,
        right: 10,
      ),
      child: Row(
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
                            alignment: Alignment.centerLeft,
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
                              alignment: Alignment.centerLeft,
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
                                        color: CustomColors.blackText
                                            .withOpacity(0.8),
                                      ),
                                    ),
                                    TextSpan(
                                      text: controller.togetherDate.value
                                          .toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: CustomColors.blackText,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '일째',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
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
    return Container(
      width: 300,
      height: 105,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, 5),
            blurRadius: 5,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _achievementDetail(
                  '리스트', controller.bukkungListCount.value.toString()),
              _achievementDetail('조회수', controller.viewCount.value.toString()),
              _achievementDetail('좋아요', controller.likeCount.value.toString()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _achievementDetail(String title, String content) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        Text(
          content,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w800,
            decoration: TextDecoration.underline,
            height: 2,
          ),
        ),
      ],
    );
  }

  Widget _levelCircularBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(240),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: Offset(0, 15),
              blurRadius: 10,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: Offset(0, -15),
              blurRadius: 10,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: Offset(15, 0),
              blurRadius: 10,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: Offset(-15, 0),
              blurRadius: 10,
            ),
          ],
        ),
        child: Obx(
          () => Stack(
            children: [
              Center(
                child: SizedBox(
                  height: 180,
                  width: 180,
                  child: CircularProgressIndicator(
                    strokeWidth: 8,
                    value: (controller.expPoint.value % 100) / 100,
                    color: CustomColors.mainPink,
                  ),
                ),
              ),
              Center(
                child: Container(
                  height: 180,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'LV.${((controller.expPoint.value - (controller.expPoint.value % 100)) / 100).toInt().toString()}',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 30,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '${(controller.expPoint.value % 100).toString()}%',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          controller.refreshAchievement();
                        },
                        child: Icon(
                          Icons.refresh,
                          size: 30,
                          color: CustomColors.darkGrey,
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chatButton() {
    return GestureDetector(
      onTap: () {
        controller.openChatUrl();
      },
      child: Container(
        height: 50,
        width: 350,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: CustomColors.backgroundLightGrey,
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.2),
              offset: Offset(0, -5),
              blurRadius: 5,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: Offset(0, 5),
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 30),
            Icon(
              Icons.chat,
              size: 30,
              color: CustomColors.darkGrey,
            ),
            SizedBox(width: 20),
            Text(
              '1:1 문의사항 (카카오톡 문의하기)',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
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
