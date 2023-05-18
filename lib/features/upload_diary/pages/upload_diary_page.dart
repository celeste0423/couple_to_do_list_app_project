import 'package:couple_to_do_list_app/features/upload_diary/controller/upload_diary_controller.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:couple_to_do_list_app/widgets/auxiliary_button.dart';
import 'package:couple_to_do_list_app/widgets/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UploadDiaryPage extends GetView<UploadDiaryController> {
  const UploadDiaryPage({super.key});

  PreferredSizeWidget _appBar() {
    return AppBar(
      //Todo : 데이터 채우기
      title: Text('데이터 채우기'),
      leading: TextButton(
        onPressed: () {
          Get.back();
        },
        child: Text(
          '취소',
          style: TextStyle(color: CustomColors.greyText),
        ),
      ),
    );
  }

  Widget _datePicker(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Row(
        children: [
          Image.asset(
            'assets/icons/calendar.png',
            width: 35,
            color: Colors.black.withOpacity(0.6),
            colorBlendMode: BlendMode.modulate,
          ),
          SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: () {
                controller.datePicker(context);
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Obx(() {
                    return Text(
                      controller.diaryDateTime.value == null
                          ? '예상 날짜'
                          : DateFormat('yyyy-MM-dd')
                              .format(controller.diaryDateTime.value!),
                      style: TextStyle(
                        color: controller.diaryDateTime.value == null
                            ? CustomColors.greyText
                            : CustomColors.blackText,
                        fontSize: 25,
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/icons/image.png',
            width: 35,
            color: Colors.black.withOpacity(0.6),
            colorBlendMode: BlendMode.modulate,
          ),
          SizedBox(width: 10),
          Container(
            width: 170,
            height: 170,
            decoration: BoxDecoration(
              color: CustomColors.lightGrey,
              borderRadius: BorderRadius.circular(25),
              image: DecorationImage(
                image: NetworkImage(
                  'https://post-phinf.pstatic.net/MjAxNzEwMjBfNjYg/MDAxNTA4NDY0NzkxMDc3.BXMDJ0jGbaunHr6TRI6N4NOBiGOXAlXbzlmgaZYHMkQg.P6Rbnq9YTv9CCqH5Vgu6JCSEGZC_wOZ25onOnoT4AAAg.PNG/11.png?type=w1200',
                ),
                fit: BoxFit.cover,
              ),
            ),

            //사진이 없을경우 기본 이미지 꼬물이로
            // child: Image.asset(
            //   'assets/images/ggomool.png',
            //   width: 170,
            //   height: 170,
            // ),
          ),
        ],
      ),
    );
  }

  Widget _contentTextField() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        //Todo: 이거 수정해야될듯 높이
        //height: Get.height - 470,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        child: TextField(
          controller: controller.contentController,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          onChanged: (value) {},
          style: TextStyle(
            color: CustomColors.blackText,
            fontSize: 25,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: '나의 소감',
            hintStyle: TextStyle(
              color: CustomColors.greyText,
              fontSize: 25,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(UploadDiaryController());
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: CustomColors.backgroundLightGrey,
      appBar: _appBar(),
      body: Column(
        children: [
          customDivider(),
          _datePicker(context),
          _imagePicker(),
          _contentTextField(),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 5, 30, 20),
            child: auxiliaryButton('저장', () {}),
          )
        ],
      ),
    );
  }
}
