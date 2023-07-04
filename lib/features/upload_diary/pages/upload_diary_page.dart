import 'package:couple_to_do_list_app/features/upload_diary/controller/upload_diary_controller.dart';
import 'package:couple_to_do_list_app/helper/show_alert_dialog.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:couple_to_do_list_app/widgets/auxiliary_button.dart';
import 'package:couple_to_do_list_app/widgets/category_icon.dart';
import 'package:couple_to_do_list_app/widgets/main_button.dart';
import 'package:couple_to_do_list_app/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UploadDiaryPage extends GetView<UploadDiaryController> {
  UploadDiaryPage({super.key});

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
              Icons.arrow_back_ios,
              size: 35,
            ),
          ),
        ),
        title: TitleText(
          text: '다이어리',
        ));
  }

  Widget _imagePicker() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      height: 210,
      child: Obx(() {
        return ListView(
          scrollDirection: Axis.horizontal,
          children: [
            Row(
              children: List.generate(
                controller.selectedImgFiles[0].length,
                (index) => Stack(clipBehavior: Clip.none, children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Container(
                      width: 170,
                      height: 170,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image:
                              FileImage(controller.selectedImgFiles[0][index]),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
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
      child: Container(
        padding: EdgeInsets.all(10),
        width: 170,
        height: 170,
        decoration: BoxDecoration(
          color: CustomColors.lightGrey,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
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
                  style: TextStyle(fontSize: 30),
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
                            'airplane',
                            '여행',
                            CustomColors.travel,
                            '1travel',
                          ),
                          _categoryCard(
                            'running',
                            '액티비티',
                            CustomColors.activity,
                            '3activity',
                          ),
                          _categoryCard(
                            'study',
                            '자기계발',
                            CustomColors.study,
                            '5study',
                          ),
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
                            'food',
                            '식사',
                            CustomColors.meal,
                            '2meal',
                          ),
                          _categoryCard(
                            'singer',
                            '문화활동',
                            CustomColors.culture,
                            '4culture',
                          ),
                          _categoryCard(
                            'filter-file',
                            '기타',
                            CustomColors.etc,
                            '6etc',
                          ),
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
    double numberoFlines = 7;
    double holeDiameter = 16;

    Widget contents() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
            width: (Get.width - 100 - holeDiameter) * 11 / 16,
            child: TextField(
              controller: controller.titleController,
              maxLines: 1,
              textInputAction: TextInputAction.done,
              textAlign: TextAlign.start,
              cursorColor: CustomColors.darkGrey,
              cursorHeight: 40,
              style: TextStyle(
                color: CustomColors.darkGrey,
                fontSize: 25,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15),
                hintText: '제목을 입력하세요',
                hintStyle: TextStyle(
                  color: CustomColors.darkGrey,
                  fontSize: 25,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  controller.datePicker(context);
                },
                child: Obx(() {
                  return Container(
                    width: (Get.width - 110 - holeDiameter - 20) * 1 / 2,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: CustomColors.grey),
                      ),
                    ),
                    child: Text(
                      controller.diaryDateTime.value == null
                          ? '날짜'
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
              SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  Get.dialog(_categoryDialog());
                },
                child: Obx(() {
                  return Container(
                    width: (Get.width - 110 - holeDiameter - 20) * 1 / 2,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: CustomColors.grey))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CategoryIcon(
                          category: controller.diaryCategory.value ?? '',
                          size: 25,
                        ),
                        SizedBox(width: 10),
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
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: CustomColors.grey))),
            width: (Get.width - 100 - holeDiameter) * 11 / 16,
            child: TextField(
              controller: controller.locationController,
              keyboardType: TextInputType.multiline,
              maxLines: 1,
              onChanged: (value) {},
              cursorColor: CustomColors.darkGrey,
              cursorHeight: 20,
              style: TextStyle(
                color: CustomColors.blackText,
                fontSize: 25,
                // decoration: TextDecoration.underline,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                suffixIcon: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Icon(
                    Icons.location_on_outlined,
                    color: CustomColors.lightGrey,
                    size: 25,
                  ),
                ),
                contentPadding: EdgeInsets.only(top: 20),
                hintText: '장소/위치',
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
                            hintText: ' 소감 작성하기',
                            hintStyle: TextStyle(
                              color: CustomColors.lightGreyText,
                              fontSize: 20,
                            ),
                            border: InputBorder.none,
                          ),
                          cursorColor: CustomColors.darkGrey,
                          cursorHeight: 20,
                          style: TextStyle(
                            fontSize: 28.0,
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
        auxiliaryButton('취소', () {
          Get.back();
        }, Get.width * 1 / 4),
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
                await controller.uploadDiary();
                Get.back();
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
            resizeToAvoidBottomInset: false,
            backgroundColor: CustomColors.lightPink,
            appBar: _appBar(),
            body: Column(
              children: [
                _contentContainer(context),
                _imagePicker(),
                _buttonRow(),
                SizedBox(height: 10)
              ],
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
