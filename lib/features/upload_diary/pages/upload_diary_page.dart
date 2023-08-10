import 'package:couple_to_do_list_app/features/read_diary/pages/read_diary_page.dart';
import 'package:couple_to_do_list_app/features/upload_diary/controller/upload_diary_controller.dart';
import 'package:couple_to_do_list_app/helper/open_alert_dialog.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:couple_to_do_list_app/widgets/category_icon.dart';
import 'package:couple_to_do_list_app/widgets/main_button.dart';
import 'package:couple_to_do_list_app/widgets/png_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../models/diary_model.dart';

class UploadDiaryPage extends GetView<UploadDiaryController> {
  const UploadDiaryPage({super.key});

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: CustomColors.lightPink,
      leading: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.close,
            size: 35,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
            onPressed: () async {
              if (controller.isUploading.value) {
                print('버튼 비활성화');
                null;
              } else {
                if (controller.isValid()) {
                  print('업로드 중');
                  controller.isUploading.value = true;
                  DiaryModel updatedDiary = await controller.uploadDiary();
                  Get.off(() => ReadDiaryPage(), arguments: updatedDiary);
                } else {
                  //Todo: 요소별로 경고 추가
                  if (controller.titleController.text == '') {
                    openAlertDialog(title: '제목을 입력해 주세요');
                  } else if (controller.diaryCategory.value == '') {
                    openAlertDialog(title: '카테고리를 선택해주세요');
                  } else if (controller.locationController.text == '') {
                    openAlertDialog(title: '위치를 작성해주세요');
                  } else if (controller.diaryDateTime.value == null) {
                    openAlertDialog(title: '날짜를 선택해주세요');
                  } else if (controller.contentController == '') {
                    openAlertDialog(title: '소감을 작성해주세요');
                  }
                }
              }
            },
            icon: Icon(
              Icons.check,
              size: 35,
            ),
          ),
        ),
      ],
    );
  }

  Widget _titleTextField() {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: TextField(
        controller: controller.titleController,
        maxLines: 1,
        textInputAction: TextInputAction.done,
        textAlign: TextAlign.start,
        cursorColor: CustomColors.darkGrey,
        maxLength: 15,
        style: TextStyle(
          color: CustomColors.darkGrey,
          fontFamily: 'Pyeongchang',
          fontSize: 30,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.only(left: 15),
          counterText: '',
          hintText: '제목을 입력하세요',
          hintStyle: TextStyle(
            color: CustomColors.greyText,
            fontFamily: 'Pyeongchang',
            fontSize: 30,
          ),
        ),
      ),
    );
  }

  Widget _imagePicker() {
    return SizedBox(
      height: 390,
      child: Obx(() {
        return ListView(
          scrollDirection: Axis.horizontal,
          children: [
            SizedBox(width: 30),
            Row(
              children: List.generate(
                controller.selectedImgFiles[0].length,
                (index) => Stack(clipBehavior: Clip.none, children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      bottom: 50,
                      top: 10,
                    ),
                    child: Container(
                      width: 330,
                      height: 330,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 0,
                            offset: Offset(0, 5),
                          ),
                        ],
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image:
                              FileImage(controller.selectedImgFiles[0][index]),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 0,
                    child: GestureDetector(
                      onTap: () {
                        controller.selectedImgFiles[0].removeAt(index);
                        controller.selectedImgFiles[1].removeAt(index);
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: CustomColors.backgroundLightGrey,
                          borderRadius: BorderRadius.circular(30),
                          //shape: BoxShape.circle,
                        ),
                        child: Center(
                            child: Icon(
                          Icons.remove_circle,
                          size: 30,
                          color: Colors.red,
                        )),
                      ),
                    ),
                  )
                ]),
              ),
            ),
            imageAddButton(),
            SizedBox(width: 20),
          ],
        );
      }),
    );
  }

  Widget imageAddButton() {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        controller.pickMultipleImages();
      },
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          bottom: 50,
          top: 10,
        ),
        child: Container(
          width: 330,
          height: 330,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(60),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 0,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: CustomColors.darkGrey,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 15),
              Text(
                '이미지 추가',
                style: TextStyle(
                    fontSize: 20,
                    color: CustomColors.darkGrey,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _contentRow() {
    return Positioned(
      top: 410,
      left: Get.width / 2 - 165,
      child: Container(
        width: 330,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 0,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(width: 20),
            Row(
              children: [
                PngIcon(
                  iconName: 'location-pin',
                  iconSize: 30,
                ),
                SizedBox(width: 5),
                SizedBox(
                  width: 120,
                  child: TextField(
                    controller: controller.locationController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 1,
                    onChanged: (value) {},
                    cursorColor: CustomColors.darkGrey,
                    cursorHeight: 20,
                    style: TextStyle(
                      color: CustomColors.blackText,
                      fontSize: 18,
                      // decoration: TextDecoration.underline,
                    ),
                    maxLength: 20,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      counterText: '',
                      hintText: '장소',
                      hintStyle: TextStyle(
                        color: CustomColors.greyText,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                PngIcon(
                  iconName: 'category',
                  iconSize: 30,
                  iconColor: CustomColors.grey.withOpacity(0.5),
                ),
                GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    Get.dialog(_categoryDialog());
                  },
                  child: Obx(() {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CategoryIcon(
                          category: controller.diaryCategory.value ?? '',
                          size: 35,
                        ),
                        SizedBox(width: 5),
                        Text(
                          controller.categoryToString[
                                  controller.diaryCategory.value] ??
                              '카테고리',
                          style: TextStyle(
                            color: controller.categoryToString[
                                        controller.diaryCategory.value] ==
                                    null
                                ? CustomColors.greyText
                                : CustomColors.blackText,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _contentTextField(BuildContext context) {
    return Container(
      color: CustomColors.backgroundLightGrey,
      height: Get.height -
          494-
          context.mediaQueryPadding.top -
          context.mediaQueryPadding.bottom,
      child: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller.contentController,
              scrollPadding: const EdgeInsets.only(bottom: 300),
              decoration: InputDecoration(
                hintText: ' 소감은 어땠나요?',
                hintStyle: TextStyle(
                  color: CustomColors.lightGreyText,
                  fontSize: 18,
                  fontFamily: 'Bookk_mj',
                ),
                border: InputBorder.none,
                counterText: '',
              ),
              cursorColor: CustomColors.darkGrey,
              cursorHeight: 20,
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Bookk_mj',
                height: 1.2,
              ),
              keyboardType: TextInputType.multiline,
              expands: false,
              maxLines: 5,
              maxLength: 140,
            ),
            GestureDetector(
              onTap: () {
                controller.datePicker(context);
              },
              child: Obx(() {
                return Row(
                  children: [
                    PngIcon(
                      iconName: 'calendar',
                      iconColor: CustomColors.grey.withOpacity(0.5),
                      iconSize: 25,
                    ),
                    SizedBox(width: 10),
                    Text(
                      controller.diaryDateTime.value == null
                          ? '날짜'
                          : DateFormat('yyyy-MM-dd')
                              .format(controller.diaryDateTime.value!),
                      style: TextStyle(
                        color: controller.diaryDateTime.value == null
                            ? CustomColors.greyText
                            : CustomColors.blackText,
                        fontSize: 18,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: SizedBox(
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
                  style: TextStyle(fontSize: 25),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 450,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _categoryCard(
                              'airplane', '여행', CustomColors.travel, '1travel'),
                          _categoryCard('running', '액티비티',
                              CustomColors.activity, '3activity'),
                          _categoryCard(
                              'study', '자기계발', CustomColors.study, '5study'),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    SizedBox(
                      height: 450,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _categoryCard(
                              'food', '식사', CustomColors.meal, '2meal'),
                          _categoryCard('singer', '문화활동', CustomColors.culture,
                              '4culture'),
                          _categoryCard(
                              'filter-file', '기타', CustomColors.etc, '6etc'),
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
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _contentContainer(context) {
    double numberoFlines = 7;
    double holeDiameter = 16;

    Widget contents() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 20,
              ),
            ],
          ),
        ],
      );
    }

    Widget circleHole() {
      return Container(
        margin: EdgeInsets.all(10),
        width: holeDiameter,
        height: holeDiameter,
        decoration: BoxDecoration(
          color: CustomColors.redbrown.withOpacity(0.45),
          shape: BoxShape.circle,
        ),
      );
    }

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        padding: EdgeInsets.fromLTRB(0, 20, 20, 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: CustomColors.backgroundLightGrey,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (int i = 0; i < 6; i++) circleHole(),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                contents(),
                Stack(
                  children: [
                    for (int lines = 0; lines < numberoFlines; lines++)
                      Container(
                        width: Get.width - 110 - holeDiameter,
                        margin: EdgeInsets.only(
                          top: 7 + (lines + 1) * 28,
                        ),
                        height: 1,
                        color: CustomColors.grey,
                      ),
                    SizedBox(
                      height: 28 * (numberoFlines + 2),
                      width: Get.width - 100 - holeDiameter,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                          controller: controller.contentController,
                          decoration: InputDecoration(
                            hintText: ' 소감은 어땠나요?',
                            hintStyle: TextStyle(
                              color: CustomColors.lightGreyText,
                              fontSize: 18,
                              fontFamily: 'Bookk_mj',
                            ),
                            border: InputBorder.none,
                          ),
                          cursorColor: CustomColors.darkGrey,
                          cursorHeight: 20,
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Bookk_mj',
                          ),
                          keyboardType: TextInputType.multiline,
                          expands: false,
                          maxLines: numberoFlines.toInt(),
                          maxLength: 140,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        MainButton(
          buttonText: '취소',
          buttonColor: Colors.white,
          textColor: CustomColors.mainPink,
          onTap: () {
            Get.back();
          },
        ),
        MainButton(
          buttonText: controller.selectedDiaryModel == null ? '작성 완료' : '수정 완료',
          onTap: () async {
            if (controller.isUploading.value) {
              print('버튼 비활성화');
              null;
            } else {
              if (controller.isValid()) {
                print('업로드 중');
                controller.isUploading.value = true;
                DiaryModel updatedDiary = await controller.uploadDiary();
                Get.off(() => ReadDiaryPage(), arguments: updatedDiary);
              } else {
                openAlertDialog(title: '다이어리를 빠짐없이 작성해 주세요');
              }
            }
          },
          width: Get.width * 5 / 8,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(UploadDiaryController());
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: CustomColors.lightPink,
            appBar: _appBar(),
            body: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      _titleTextField(),
                      _imagePicker(),
                      _contentTextField(context),
                    ],
                  ),
                  _contentRow(),
                ],
              ),
            ),
          ),
          Obx(
            () => controller.isUploading.value
                ? Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: CustomColors.mainPink,
                      ),
                    ),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}
