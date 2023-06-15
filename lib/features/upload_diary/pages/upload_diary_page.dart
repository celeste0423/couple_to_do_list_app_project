import 'package:couple_to_do_list_app/features/upload_diary/controller/upload_diary_controller.dart';
import 'package:couple_to_do_list_app/features/upload_diary/widgets/location_text_field.dart';
import 'package:couple_to_do_list_app/features/upload_diary/widgets/underlined_textfield.dart';
import 'package:couple_to_do_list_app/helper/show_alert_dialog.dart';
import 'package:couple_to_do_list_app/models/diary_model.dart';
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
  // Widget _Title() {
  //   if (title == null) {
  //     return TextField(
  //       controller: controller.titleController,
  //       maxLines: null,
  //       textInputAction: TextInputAction.done,
  //       textAlign: TextAlign.center,
  //       style: TextStyle(
  //         color: CustomColors.darkGrey,
  //         fontSize: 40,
  //       ),
  //       decoration: const InputDecoration(
  //         prefixIcon: Icon(
  //           Icons.edit,
  //           color: CustomColors.darkGrey,
  //           size: 30,
  //         ),
  //         suffixIcon: Icon(
  //           Icons.edit,
  //           color: CustomColors.darkGrey,
  //           size: 30,
  //         ),
  //         border: InputBorder.none,
  //         focusedBorder: InputBorder.none,
  //         enabledBorder: InputBorder.none,
  //         errorBorder: InputBorder.none,
  //         disabledBorder: InputBorder.none,
  //         contentPadding: EdgeInsets.only(left: 15),
  //         hintText: '제목을 입력하세요',
  //         hintStyle: TextStyle(
  //           color: CustomColors.darkGrey,
  //           fontSize: 40,
  //         ),
  //       ),
  //     );
  //   } else {
  //     return Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //       children: [
  //         titleText(title!),
  //         Icon(
  //           Icons.edit,
  //           size: 30,
  //         ),
  //       ],
  //     );
  //   }
  // }

  final DiaryModel? selectedDiaryModel = Get.arguments;

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: CustomColors.lightPink,
      title: Center(
        child: TextField(
          controller: controller.titleController,
          maxLines: 1,
          textInputAction: TextInputAction.done,
          textAlign: TextAlign.start,
          style: TextStyle(
            color: CustomColors.darkGrey,
            fontSize: 40,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding: EdgeInsets.only(left: 15),
            hintText: selectedDiaryModel != null
                ? selectedDiaryModel!.title!
                : '제목을 입력하세요',
            suffixIcon: Icon(
              Icons.edit,
              size: 23,
              color: CustomColors.grey,
            ),
            hintStyle: TextStyle(
              color: CustomColors.darkGrey,
              fontSize: 40,
            ),
          ),
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.abc),
        onPressed: () {
          controller.pickMultipleImages();
        },
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
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Obx(() {
                    return Text(
                      //todo: controller 에서 diaryDateTime initialize  했는지 확인
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
    Widget chooseimageContainer() {
      return GestureDetector(
        onTap: () {
          print('이미지 추가 버튼 누름!');
          FocusManager.instance.primaryFocus?.unfocus();
          controller.pickMultipleImages;
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
            )),
      );
    }

    Widget _mygridView() {
      if (controller.selectedImages.isEmpty) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/icons/image.png',
              width: 35,
              color: Colors.black.withOpacity(0.6),
              colorBlendMode: BlendMode.modulate,
            ),
            SizedBox(width: 10),
            chooseimageContainer(),
          ],
        );
      } else {
        return SizedBox(
          height: 170,
          child: ListView.builder(
            itemCount: controller.selectedImages.length+1,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            // gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            //     maxCrossAxisExtent: 10, mainAxisSpacing: 20),
            itemBuilder: (context, index) {
              if (index == 0) {
                return chooseimageContainer();
              } else {
                return Container(
                    width: 170,
                    height: 170,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),
                    image: DecorationImage(fit: BoxFit.cover, image: FileImage(controller.selectedImages[index - 1]))),
                    );
              }
            },
          ),
        );
      }
    }

    Widget myImagePickerContainer() {
      if (selectedDiaryModel != null &&
          selectedDiaryModel!.imgUrlList!.isNotEmpty) {
        return Obx(() => _mygridView());
      } else {
        return Obx(() => _mygridView());
      }
    }

    DecorationImage? myDecorationImage() {
      //새로운 다이어리를 만드는경우이거나 다이어리 수정하는데 사진이 없는 경우가 아니면 이미지 보이게 함
      if (selectedDiaryModel == null) {
        return null;
      } else {
        if (selectedDiaryModel!.imgUrlList == null) {
          return null;
        } else {
          return DecorationImage(
            image: NetworkImage(
              selectedDiaryModel!.imgUrlList![0],
            ),
            fit: BoxFit.cover,
          );
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: myImagePickerContainer(),
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
              style: TextStyle(fontSize: 25, color: CustomColors.blackText),
            ),
          ],
        ),
      ),
    );
  }

  Widget _contentContainer(context) {
    double numberoflines = 8;
    double holediameter = 16;

    Widget contents() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  controller.datePicker(context);
                },
                child: Obx(() {
                  return Container(
                    width: (Get.width - 110 - holediameter - 20) * 1 / 2,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: CustomColors.grey))),
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
                    width: (Get.width - 110 - holediameter - 20) * 1 / 2,
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
            width: (Get.width - 100 - holediameter) * 11 / 16,
            child: TextField(
              controller: controller.locationController,
              keyboardType: TextInputType.multiline,
              maxLines: 1,
              onChanged: (value) {},
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
        width: holediameter,
        height: holediameter,
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
              children: [for (int i = 0; i < 6; i++) circleHole()],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                contents(),
                Stack(
                  children: [
                    for (int i = 0; i < numberoflines; i++)
                      Container(
                        width: Get.width - 110 - holediameter,
                        margin: EdgeInsets.only(
                          top: 7 + (i + 1) * 28,
                        ),
                        height: 1,
                        color: CustomColors.grey,
                      ),
                    SizedBox(
                      height: 28 * (numberoflines + 2),
                      width: Get.width - 100 - holediameter,
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
                              border: InputBorder.none),
                          cursorHeight: 15,
                          style: TextStyle(
                            fontSize: 28.0,
                          ),
                          keyboardType: TextInputType.multiline,
                          expands: false,
                          maxLines: numberoflines.toInt(),
                          maxLength: 170,
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
        mainButton('다이어리 작성', () async {
          if (controller.isValid()) {
            print('isvalid');
            await controller.uploadDiary();
            print('uploadDiary Complete');
            Get.back();
          } else {
            openAlertDialog(title: '다이어리를 빠짐없이 작성해 주세요');
          }
        }, Get.width * 5 / 8)
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
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: CustomColors.lightPink,
        appBar: _appBar(),
        body: Column(
          children: [
            _contentContainer(context),
            _imagePicker(),
            _buttonRow(),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
