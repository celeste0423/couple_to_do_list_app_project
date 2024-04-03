import 'package:couple_to_do_list_app/src/features/setting/controller/auth_delete_page_controller.dart';
import 'package:couple_to_do_list_app/src/utils/custom_color.dart';
import 'package:couple_to_do_list_app/src/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthDeletePage extends GetView<AuthDeletePageController> {
  const AuthDeletePage({Key? key}) : super(key: key);
//asdas

  Widget _surveySelector() {
    return Obx(
      () => Column(
        children: [
          _surveyTile('자주 사용하지 않아요', '자주 사용하지 않아요', false),
          _surveyTile('앱 오류가 많아요', '앱 오류가 많아요', false),
          _surveyTile('UI/UX가 불편해요', 'UI/UX가 불편해요', false),
          _surveyTile('기록을 삭제하고 싶어요', '기록을 삭제하고 싶어요', false),
          _surveyTile('더 이상 필요가 없어졌어요', '더 이상 필요가 없어졌어요', false),
          _surveyTile('직접입력', controller.feedbackController.text, true),
          AnimatedContainer(
            height: controller.isFeedback.value ? 150 : 0,
            duration: Duration(milliseconds: 200),
            color: Colors.grey.withOpacity(0.2),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: TextField(
                controller: controller.feedbackController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onTap: () {
                  controller.pageScrollController.animateTo(
                    controller.pageScrollController.position.maxScrollExtent,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.ease,
                  );
                },
                style: TextStyle(
                  color: CustomColors.blackText,
                  fontSize: 15,
                  fontFamily: 'Roboto',
                ),
                cursorColor: CustomColors.darkGrey,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: '피드백을 참고하여 더 나은 서비스가 되도록 개선하겠습니다.',
                  hintStyle: TextStyle(
                    color: CustomColors.greyText,
                    fontSize: 15,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _surveyTile(String text, String value, bool isFeedback) {
    return ListTile(
      title: Text(
        text,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 20,
          color: Colors.black.withOpacity(0.8),
        ),
      ),
      leading: Radio<String>(
        activeColor: CustomColors.mainPink,
        value: value,
        groupValue: controller.surveyResult.value,
        onChanged: (String? value) {
          if (isFeedback) {
            controller.isFeedback(true);
          } else {
            controller.isFeedback(false);
          }
          controller.surveyResult(value);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(AuthDeletePageController());
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: CustomColors.mainPink,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          controller: controller.pageScrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '버꿍리스트를 정말 탈퇴하시겠어요?',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.9),
                ),
              ),
              SizedBox(height: 10),
              Text(
                '탈퇴하는 이유를 알려주시면 더 좋은 서비스를 제공하는데 참고하겠습니다.',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(20),
                color: Colors.red.withOpacity(0.15),
                child: Text(
                  '탈퇴할 경우 버꿍리스트와 다이어리 기록, 프로필 등 모든 데이터가 삭제되고 복구가 불가능 합니다.',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Roboto',
                    color: Colors.red,
                  ),
                ),
              ),
              SizedBox(height: 10),
              _surveySelector(),
              SizedBox(height: 70),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: MainButton(
                buttonText: '취소',
                buttonColor: Colors.black45,
                onTap: () => Get.back(),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: MainButton(
                buttonText: '탈퇴하기',
                buttonColor: Colors.red,
                //todo:회원탈퇴 storage삭제(사진같은거) 삭제 해야 하나? 이거 버꿍리스트에 올라간거 있을텐데... 다이어리만 삭제해야 하나
                onTap: () => controller.authDeletion(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
