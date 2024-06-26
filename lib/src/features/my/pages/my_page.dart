import 'package:auto_size_text/auto_size_text.dart';
import 'package:couple_to_do_list_app/src/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/src/features/auth/pages/find_buddy_page.dart';
import 'package:couple_to_do_list_app/src/features/my/controller/my_page_controller.dart';
import 'package:couple_to_do_list_app/src/features/setting/pages/setting_page.dart';
import 'package:couple_to_do_list_app/src/features/suggestion_list/pages/suggestion_list_page.dart';
import 'package:couple_to_do_list_app/src/utils/custom_color.dart';
import 'package:couple_to_do_list_app/src/widgets/png_icons.dart';
import 'package:couple_to_do_list_app/src/widgets/title_text.dart';
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
        // IconButton(
        //   onPressed: () {
        //     Get.to(() => StorePage());
        //   },
        //   icon: Icon(Icons.local_grocery_store_outlined, size: 35, weight: 10,)
        // ),
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
          _achievement(),
        ],
      ),
    );
  }

  Widget _cardBackground(context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(
              color: CustomColors.mainPink,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
            ),
            child: _nickname(context),
          ),
        ),
        Obx(() {
          return !controller.isKeyboard.value
              ? Expanded(
                  flex: 6,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 50),
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: _levelCircularBar(),
                          ),
                        ),
                        Obx(() {
                          return !controller.isKeyboard.value
                              ? _description()
                              : Container();
                        }),
                        _chatButton(),
                      ],
                    ),
                  ),
                )
              : Container();
        }),
        Expanded(
          flex: 2,
          child: Container(),
        ),
      ],
    );
  }

  Widget _nickname(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Expanded(
            flex: 6,
            child: FittedBox(
              fit: BoxFit.scaleDown,
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
                                    focusNode: controller.nicknameFocusNode,
                                    maxLengthEnforcement:
                                        MaxLengthEnforcement.enforced,
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
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Obx(
                              () => controller.isSolo.value
                                  ? GestureDetector(
                                      onTap: () {
                                        Get.offAll(
                                          FindBuddyPage(
                                            email: AuthController
                                                .to.user.value.email!,
                                          ),
                                        );
                                      },
                                      child: AutoSizeText(
                                        '여기를 눌러 짝꿍을 연결하세요',
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: CustomColors.blackText,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
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
                                                        text: controller
                                                            .buddyNickname
                                                            .value,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Pyeongchang',
                                                          fontSize: 20,
                                                          color: CustomColors
                                                              .blackText,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: ' 님과 함께한 지 ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w200,
                                                          fontSize: 18,
                                                          color: CustomColors
                                                              .blackText
                                                              .withOpacity(0.8),
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: controller
                                                            .togetherDate.value
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20,
                                                          color: CustomColors
                                                              .blackText,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: '일째',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20,
                                                          color: CustomColors
                                                              .blackText,
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
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
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
            ),
          ),
          Expanded(flex: 4, child: Container()),
        ],
      ),
    );
  }

  Widget _achievement() {
    return Obx(() {
      return !controller.isKeyboard.value
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 3, child: Container()),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => SuggestionListPage(), arguments: 4);
                    },
                    child: Container(
                      width: 300,
                      height: 101,
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _achievementDetail('리스트',
                                controller.bukkungListCount.value.toString()),
                            _achievementDetail(
                                '조회수', controller.viewCount.value.toString()),
                            // _achievementDetail('받은 좋아요',
                            //     controller.likeCount.value.toString()),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(flex: 10, child: Container()),
              ],
            )
          : Container();
    });
  }

  Widget _achievementDetail(String title, String content) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
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
      ),
    );
  }

  Widget _levelCircularBar() {
    return Obx(() {
      return !controller.isKeyboard.value
          ? Padding(
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
                child: Stack(
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
                      child: SizedBox(
                        height: 180,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'LV.${(controller.expPoint.value - (controller.expPoint.value % 100)) ~/ 100}',
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
            )
          : Container();
    });
  }

  Widget _description() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Text(
        '자신이 올린 리스트의 조회수와 좋아요 수가 \n늘어날 수록 레벨이 올라가요!',
        style: TextStyle(color: CustomColors.greyText, fontSize: 12),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _chatButton() {
    return Obx(() {
      return !controller.isKeyboard.value
          ? GestureDetector(
              onTap: () {
                controller.openChatUrl();
              },
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Container(
                  height: 40,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  width: Get.width - 80,
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
                      SizedBox(width: 20),
                      Icon(
                        Icons.chat,
                        size: 20,
                        color: CustomColors.darkGrey,
                      ),
                      SizedBox(width: 20),
                      SizedBox(
                        width: Get.width - 80 - 20 - 20 - 20,
                        child: AutoSizeText(
                          '1:1 문의사항 (카카오톡 문의하기)',
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Container();
    });
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
        resizeToAvoidBottomInset: false,
        appBar: _appBar(),
        body: _myPage(context),
      ),
    );
  }
}
