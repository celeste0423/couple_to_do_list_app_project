import 'package:couple_to_do_list_app/features/upload_bukkung_list/controller/upload_bukkung_list_controller.dart';
import 'package:couple_to_do_list_app/features/upload_bukkung_list/widgets/location_text_field.dart';
import 'package:couple_to_do_list_app/helper/show_alert_dialog.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:couple_to_do_list_app/widgets/category_icon.dart';
import 'package:couple_to_do_list_app/widgets/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UploadBukkungListPage extends GetView<UploadBukkungListController> {
  UploadBukkungListPage({Key? key}) : super(key: key);

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
                ? () {
                    controller.uploadBukkungList();
                    Get.back();
                  }
                : () {
                    openAlertDialog(title: '값을 모두 입력해 주세요');
                  },
            child: controller.isCompleted.value == true
                ? Text('저장', style: TextStyle(color: CustomColors.mainPink))
                : Text(
                    '저장',
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
        maxLines: null,
        textInputAction: TextInputAction.done,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: CustomColors.blackText,
          fontSize: 30,
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
            color: CustomColors.greyText,
            fontSize: 30,
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
          Image.asset(
            'assets/icons/category.png',
            width: 35,
            color: Colors.black.withOpacity(0.6),
            colorBlendMode: BlendMode.modulate,
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
                            fontSize: 25,
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

  Widget _locationTextfield(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Row(
        children: [
          Image.asset(
            'assets/icons/location-pin.png',
            width: 35,
            color: Colors.black.withOpacity(0.6),
            colorBlendMode: BlendMode.modulate,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: LocationTextField(),
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
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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

  Widget _contentTextField() {
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
          hintText: '계획을 작성해 주세요',
          hintStyle: TextStyle(
            color: CustomColors.greyText,
            fontSize: 25,
          ),
        ),
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
            child: Image.asset(
              'assets/icons/image.png',
              width: 35,
              color: Colors.black.withOpacity(0.6),
              colorBlendMode: BlendMode.modulate,
            ),
          ),
        ),
      );
    });
  }

  // Widget _imagePicker(BuildContext context) {
  //   return Container(
  //     height: 45,
  //     width: 55,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(25),
  //       color: Colors.white,
  //     ),
  //     child: GestureDetector(
  //       onTap: () {
  //         showModalBottomSheet(
  //           context: context,
  //           builder: (context) {
  //             return Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 ShortHBar(),
  //                 Padding(
  //                   padding: const EdgeInsets.symmetric(vertical: 20),
  //                   child: Row(
  //                     children: [
  //                       const SizedBox(width: 20),
  //                       const Text(
  //                         '버꿍 리스트 사진 업로드',
  //                         style: TextStyle(
  //                           fontSize: 25,
  //                         ),
  //                       ),
  //                       const Spacer(),
  //                       GestureDetector(
  //                         onTap: () => Navigator.pop(context),
  //                         child: Icon(
  //                           Icons.close_rounded,
  //                           color: Colors.grey,
  //                           size: 25,
  //                         ),
  //                       ),
  //                       const SizedBox(width: 15),
  //                     ],
  //                   ),
  //                 ),
  //                 customDivider(),
  //                 const SizedBox(height: 15),
  //                 Row(
  //                   children: [
  //                     const SizedBox(width: 20),
  //                     imagePickerIcon(
  //                       onTap: () {
  //                         controller.pickImageFromCamera(context);
  //                       },
  //                       icon: Icon(
  //                         Icons.camera_alt_rounded,
  //                         color: Colors.white,
  //                         size: 35,
  //                       ),
  //                       text: '카메라',
  //                     ),
  //                     const SizedBox(width: 15),
  //                     imagePickerIcon(
  //                       onTap: () async {
  //                         Navigator.pop(context);
  //                         final image = await Navigator.of(context).push(
  //                           MaterialPageRoute(
  //                             builder: (context) => ImagePickerPage(),
  //                           ),
  //                         );
  //                         if (image == null) return;
  //                         controller.imageGallery = image;
  //                         controller.imageCamera = null;
  //                       },
  //                       icon: Icon(
  //                         Icons.photo_camera_back_rounded,
  //                         color: Colors.white,
  //                         size: 35,
  //                       ),
  //                       text: '갤러리',
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 15),
  //               ],
  //             );
  //           },
  //         );
  //       },
  //       child: Center(
  //         child: Image.asset(
  //           'assets/icons/image.png',
  //           width: 35,
  //           color: Colors.black.withOpacity(0.6),
  //           colorBlendMode: BlendMode.modulate,
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // imagePickerIcon({
  //   required VoidCallback onTap,
  //   required Icon icon,
  //   required String text,
  // }) {
  //   return Column(
  //     children: [
  //       GestureDetector(
  //         onTap: onTap,
  //         child: Container(
  //           width: 50,
  //           height: 50,
  //           decoration: BoxDecoration(
  //             color: CustomColors.lightPink,
  //             borderRadius: BorderRadius.circular(50),
  //           ),
  //           child: icon,
  //         ),
  //       ),
  //       const SizedBox(height: 20),
  //       Text(
  //         text,
  //         style: TextStyle(
  //           color: CustomColors.greyText,
  //           fontSize: 20,
  //         ),
  //       )
  //     ],
  //   );
  // }

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
                fontSize: 18,
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
    Get.put(UploadBukkungListController());
    return Scaffold(
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
                          _contentTextField(),
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 15,
                              left: 30,
                              right: 30,
                            ),
                            child: Get.arguments == null
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
    );
  }
}
