import 'package:couple_to_do_list_app/features/upload_bukkung_list/controller/upload_bukkung_list_controller.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:couple_to_do_list_app/widgets/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UploadBukkungListPage extends GetView<UploadBukkungListController> {
  const UploadBukkungListPage({Key? key}) : super(key: key);

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
        TextButton(
          onPressed: () {},
          child: Text(
            '저장',
            style: TextStyle(color: CustomColors.greyText),
          ),
        ),
      ],
    );
  }

  Widget _titleTextField() {
    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller.titleController,
        maxLines: null, //여러줄을 입력할 수 있게 됨
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

  Widget _categorySelector() {
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
            child: PopupMenuButton<String>(
              offset: Offset(0, 0),
              shape: ShapeBorder.lerp(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0)),
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0)),
                1,
              ),
              onSelected: (String listCategory) {
                controller.listCategory.value = listCategory;
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    value: "icon",
                    child: Container(
                      width: 150,
                      height: 150,
                      color: CustomColors.travel,
                      child: Text(
                        "유형별",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Yoonwoo',
                          letterSpacing: 1.5,
                          color: CustomColors.darkGrey,
                        ),
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: "date",
                    child: Text(
                      "날짜 순",
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Yoonwoo',
                        letterSpacing: 1.5,
                        color: CustomColors.darkGrey,
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: "like",
                    child: Text(
                      "좋아요 순",
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Yoonwoo',
                        letterSpacing: 1.5,
                        color: CustomColors.darkGrey,
                      ),
                    ),
                  ),
                ];
              },
              child: Obx(() {
                return Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Text(
                      controller.categoryToString[
                              controller.listCategory.value] ??
                          '',
                      style: TextStyle(
                        color: CustomColors.greyText,
                        fontSize: 25,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _locationTextField() {
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
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  '장소',
                  style: TextStyle(
                    color: CustomColors.greyText,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _datePicker() {
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
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  '예상 날짜',
                  style: TextStyle(
                    color: CustomColors.greyText,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contentTextField() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                //키보드 자동닫힘
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Column(
                children: [
                  _titleTextField(),
                  customDivider(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _categorySelector(),
                          _locationTextField(),
                          _datePicker(),
                          _contentTextField(),
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
