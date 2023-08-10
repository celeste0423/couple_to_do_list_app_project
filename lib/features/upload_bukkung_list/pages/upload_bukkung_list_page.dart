import 'package:couple_to_do_list_app/features/upload_bukkung_list/controller/upload_bukkung_list_controller.dart';
import 'package:couple_to_do_list_app/helper/open_alert_dialog.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:couple_to_do_list_app/widgets/category_icon.dart';
import 'package:couple_to_do_list_app/widgets/custom_divider.dart';
import 'package:couple_to_do_list_app/widgets/png_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UploadBukkungListPage extends StatefulWidget {
  const UploadBukkungListPage({Key? key}) : super(key: key);

  @override
  State<UploadBukkungListPage> createState() => _UploadBukkungListPageState();
}

class _UploadBukkungListPageState extends State<UploadBukkungListPage> {
  // Create an instance of your controller
  final UploadBukkungListController controller = Get.put(UploadBukkungListController());
  PreferredSizeWidget _appBar() {
    return AppBar(
      leading: TextButton(
        onPressed: () {
          Get.back();
        },
        child: Text(
          '취소',
          style: TextStyle(color: CustomColors.greyText),
        ),
      ),
      actions: [
        Obx(() {
          return TextButton(
            onPressed: controller.isCompleted.value == true
                ? () async {
              print('업로드 시작(upl page)');
              controller.isUploading.value = true;
              await controller.uploadBukkungList();
              Get.back();
              Get.back();
            }
                : () {
              if (controller.titleController.text == '') {
                openAlertDialog(title: '제목을 입력해 주세요');
              } else if (controller.listCategory.value == '') {
                openAlertDialog(title: '카테고리를 선택해주세요');
              } else if (controller.locationController.text == '') {
                openAlertDialog(title: '위치를 작성해주세요');
              } else if (controller.listDateTime.value == null) {
                openAlertDialog(title: '날짜를 선택해주세요');
              } else if (controller.contentController == '') {
                openAlertDialog(title: '세부 계획을 작성해주세요');
              }
            },
            child: controller.selectedBukkungListModel == null
                ? controller.isCompleted.value == true
                ? Text('저장', style: TextStyle(color: CustomColors.mainPink))
                : Text(
              '저장',
              style: TextStyle(color: CustomColors.greyText),
            )
                : controller.isSuggestion == true
                ? controller.isCompleted.value == true
                ? Text('내 버꿍에 추가',
                style: TextStyle(color: CustomColors.mainPink))
                : Text(
              '내 버꿍에 추가',
              style: TextStyle(color: CustomColors.greyText),
            )
                : controller.isCompleted.value == true
                ? Text('수정 완료',
                style: TextStyle(color: CustomColors.mainPink))
                : Text(
              '수정 완료',
              style: TextStyle(color: CustomColors.greyText),
            ),
          );
        }),
      ],
    );
  }

  Widget _titleTextField() {
    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller.titleController,
        maxLines: 2,
        maxLength: 20,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        textInputAction: TextInputAction.done,
        textAlign: TextAlign.left,
        style: TextStyle(
          color: CustomColors.blackText,
          fontSize: 28,
          fontFamily: "Pyeongchang",
        ),
        cursorColor: CustomColors.mainPink,
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.only(left: 15),
          hintText: '제목을 입력하세요',
          hintStyle: TextStyle(
            color: CustomColors.greyText,
            fontSize: 28,
          ),
        ),
      ),
    );
  }

  Widget _categorySelector(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Row(
        children: [
          PngIcon(
            iconName: 'category',
            iconColor: Colors.black.withOpacity(0.6),
          ),
          SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                Get.dialog(_categoryDialog());
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Obx(() {
                    return Row(
                      children: [
                        CategoryIcon(
                          category: controller.listCategory.value ?? '',
                        ),
                        SizedBox(width: 10),
                        Text(
                          controller.categoryToString[
                          controller.listCategory.value] ??
                              '카테고리',
                          style: TextStyle(
                            color: controller.categoryToString[
                            controller.listCategory.value] ==
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
              ),
            ),
          ),
        ],
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

  Widget _locationTextfield(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Row(
        children: [
          PngIcon(
            iconName: 'location-pin',
            iconColor: Colors.black.withOpacity(0.6),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              // Todo: 위치 추천 기능은 추후 제공 예정
              // child: LocationTextField(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: controller.locationController,
                  maxLength: 20,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  maxLines: 1,
                  textInputAction: TextInputAction.search,
                  style: TextStyle(
                    color: CustomColors.blackText,
                    fontSize: 18,
                  ),
                  cursorColor: CustomColors.darkGrey,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: '위치',
                    counterText: '',
                    hintStyle: TextStyle(
                      color: CustomColors.greyText,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _datePicker(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Row(
        children: [
          PngIcon(
            iconName: 'calendar',
            iconColor: Colors.black.withOpacity(0.6),
          ),
          SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: () {
                print(controller.selectedBukkungListModel!.title);
                FocusManager.instance.primaryFocus?.unfocus();
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
                  const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
                  child: Obx(() {
                    return Text(
                      controller.listDateTime.value == null
                          ? '예상 날짜'
                          : DateFormat('yyyy-MM-dd')
                          .format(controller.listDateTime.value!),
                      style: TextStyle(
                        color: controller.listDateTime.value == null
                            ? CustomColors.greyText
                            : CustomColors.blackText,
                        fontSize: 18,
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

  Widget _contentTextField(context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: Get.height - 470,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      ),
      child: TextField(
        controller: controller.contentController,
        focusNode: controller.contentFocusNode,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        onChanged: (value) {},
        style: TextStyle(
          color: CustomColors.blackText,
          fontSize: 18,
          height: 1.2,
          fontFamily: 'Bookk_mj',
        ),
        cursorColor: CustomColors.darkGrey,
        decoration: const InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: '계획을 작성해 주세요',
          hintStyle: TextStyle(
            color: CustomColors.greyText,
            fontSize: 18,
            fontFamily: 'Bookk_mj',
          ),
        ),
        onTap: (){
          //controller.scrollToContent(context);
          print(controller.bukkungList!.title);
          print(controller.selectedBukkungListModel!.title);
        },
      ),
    );
  }

  Widget _imagePicker(BuildContext context) {
    return Obx(() {
      return Container(
        height: 45,
        width: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: controller.isImage.value || controller.isSelectedImage.value
              ? CustomColors.mainPink
              : Colors.white,
        ),
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            controller.pickImageFromGallery(context);
          },
          child: Center(
            child: PngIcon(
              iconName: 'image',
              iconColor: Colors.black.withOpacity(0.6),
            ),
          ),
        ),
      );
    });
  }

  Widget _publicSwitch() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '버꿍 리스트 공개 여부 설정',
              style: TextStyle(
                color: CustomColors.greyText,
                fontSize: 15,
              ),
            ),
            Obx(() {
              return Switch(
                inactiveThumbColor: CustomColors.grey,
                value: controller.isPublic.value,
                onChanged: (value) {
                  controller.isPublic.value = value;
                },
              );
            }),
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: CustomColors.backgroundLightGrey,
          appBar: _appBar(),
          body: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus(); //키보드 자동닫힘
                  },
                  child: Column(
                    children: [
                      _titleTextField(),
                      customDivider(),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: controller.contentScrollController,
                          child: Column(
                            children: [
                              _categorySelector(context),
                              _locationTextfield(context),
                              _datePicker(context),
                              _contentTextField(context),
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 15,
                                  left: 30,
                                  right: 30,
                                ),
                                child: Get.arguments[0] == null
                                    ? Row(
                                  children: [
                                    _imagePicker(context),
                                    SizedBox(width: 10),
                                    _publicSwitch(),
                                  ],
                                )
                                    : _imagePicker(context),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
    );
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is removed from the widget tree
    controller.dispose();
    super.dispose();
  }
}