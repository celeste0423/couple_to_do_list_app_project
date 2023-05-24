import 'package:couple_to_do_list_app/features/upload_diary/controller/upload_diary_controller.dart';
import 'package:couple_to_do_list_app/features/upload_diary/widgets/location_text_field.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:couple_to_do_list_app/widgets/auxiliary_button.dart';
import 'package:couple_to_do_list_app/widgets/category_icon.dart';
import 'package:couple_to_do_list_app/widgets/custom_divider.dart';
import 'package:couple_to_do_list_app/widgets/main_button.dart';
import 'package:couple_to_do_list_app/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

//Todo: controller 가 이 페이지 꺼지면 바로 꺼지게 해야 함

class UploadDiaryPage extends GetView<UploadDiaryController> {
  final String? title;
  final String? date;
  final String? imgUrl;

  const UploadDiaryPage(this.title, this.date, this.imgUrl, {super.key});

  Widget _Title() {
    if (title == null) {
      return TextField(
        controller: controller.titleController,
        maxLines: null,
        textInputAction: TextInputAction.done,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: CustomColors.darkGrey,
          fontSize: 40,
        ),
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.edit,
            color: CustomColors.darkGrey,
            size: 30,
          ),
          suffixIcon: Icon(
            Icons.edit,
            color: CustomColors.darkGrey,
            size: 30,
          ),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.only(left: 15),
          hintText: '제목을 입력하세요',
          hintStyle: TextStyle(
            color: CustomColors.darkGrey,
            fontSize: 40,
          ),
        ),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          titleText(title!),
          Icon(
            Icons.edit,
            size: 30,
          ),
        ],
      );
    }
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      title: title != null
          ? titleText(title!)
          : TextField(
              controller: controller.titleController,
              maxLines: null,
              textInputAction: TextInputAction.done,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: CustomColors.darkGrey,
                fontSize: 40,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15),
                hintText: '제목을 입력하세요',
                hintStyle: TextStyle(
                  color: CustomColors.darkGrey,
                  fontSize: 40,
                ),
              ),
            ),
      leading: SizedBox(),
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
                          ? date ?? '예상 날짜'
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
              padding: EdgeInsets.all(10),
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                color: CustomColors.lightGrey,
                borderRadius: BorderRadius.circular(25),
                image: imgUrl == null
                    ? null
                    : DecorationImage(
                        image: NetworkImage(
                          imgUrl!,
                        ),
                        fit: BoxFit.cover,
                      ),
              ),
              child: imgUrl != null
                  ? null
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 35,
                        ),
                        Image.asset(
                          'assets/icons/add.png',
                          width: 60,
                        ),
                        Text(
                          '이미지 추가',
                          style: TextStyle(fontSize: 35, color: Colors.white),
                        )
                      ],
                    )),
        ],
      ),
    );
  }
  Widget _categoryDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Container(
        height: 550,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '카테고리',
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 450,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _categoryCard(
                              'airplane', '여행', CustomColors.travel, 'travel'),
                          _categoryCard('running', '액티비티',
                              CustomColors.activity, 'activity'),
                          _categoryCard(
                              'study', '자기계발', CustomColors.study, 'study'),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    Container(
                      height: 450,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _categoryCard(
                              'food', '식사', CustomColors.meal, 'meal'),
                          _categoryCard('singer', '문화활동', CustomColors.culture,
                              'culture'),
                          _categoryCard(
                              'filter-file', '기타', CustomColors.etc, 'etc'),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _categoryCard(String icon, String text, Color color, String category) {
    return GestureDetector(
      onTap: () {
        controller.changeCategory(category);
        Get.back();
      },
      child: Container(
        width: Get.width * 0.3,
        height: Get.width * 0.3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: color,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/$icon.png',
              width: 60,
            ),
            SizedBox(height: 10),
            Text(
              text,
              style: TextStyle(fontSize: 25, color: CustomColors.blackText),
            ),
          ],
        ),
      ),
    );
  }
  Widget _contentContainer(context) {
double x=20;
    Widget contents() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  controller.datePicker(context);
                },
                child: Obx(() {
                  return Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: CustomColors.grey)
                        )
                    ),
                    child: Text(
                      controller.diaryDateTime.value == null
                          ? date ?? ' 날짜'
                          : DateFormat('yyyy-MM-dd')
                              .format(controller.diaryDateTime.value!),
                      style: TextStyle(
                        color: controller.diaryDateTime.value == null
                            ? CustomColors.greyText
                            : CustomColors.blackText,
                        fontSize: 25,
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(width: 30,),
              GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  Get.dialog(_categoryDialog());
                },
                child: Obx(() {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: CustomColors.grey)
                      )
                    ),
                    child: Row(
                      children: [
                        CategoryIcon(
                          category: controller.DiaryCategory.value ?? '', size: 25,
                        ),
                        SizedBox(width: 10),
                        Text(
                          controller.categoryToString[
                          controller.DiaryCategory.value] ??
                              '카테고리',
                          style: TextStyle(
                            color: controller.categoryToString[
                            controller.DiaryCategory.value] ==
                                null
                                ? CustomColors.greyText
                                : CustomColors.blackText,
                            fontSize: 25,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),

            ],
          ),
          Container(
            width: (Get.width-100-x)*3/4,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: CustomColors.grey)
                )
            ),
            child: TextField(
              controller: controller.locationController,
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
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                suffixIcon: Icon(Icons.location_on_outlined, color: CustomColors.lightGrey,),
                hintText: ' 위치',
                hintStyle: TextStyle(
                  color: CustomColors.greyText,
                  fontSize: 25,
                ),
              ),
            ),
          ),
        ],
      );
    }

    circleHole() {
      return Container(
        margin: EdgeInsets.all(10),
        width: x,
        height: x,
        decoration: BoxDecoration(
          color: CustomColors.redbrown,
          shape: BoxShape.circle,
        ),
      );
    }

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        padding: EdgeInsets.fromLTRB(0, 10, 20, 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                circleHole(),
                circleHole(),
                circleHole(),
                circleHole(),
                circleHole(),
              ],
            ),
            Column(
              children: [
                contents(),
                // Divider(
                //   color: Colors.black,
                //   height: 10,
                // ),
                SizedBox(
                  width: Get.width-100-x,
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
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.redAccent), //<-- SEE HERE
                      ),
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(UploadDiaryController());
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: CustomColors.lightPink,
        body: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            _Title(),
            _contentContainer(context),
            // //todo: 버튼 타자기떄문에 위로 안올라가게
            _imagePicker(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                auxiliaryButton('취소', () {
                  Get.back();
                }, Get.width * 1 / 4),
                mainButton('다이어리 작성', () {}, Get.width * 5 / 8)
              ],
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
