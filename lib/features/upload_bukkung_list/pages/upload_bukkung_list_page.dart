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
          fontSize: 25,
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
            fontSize: 25,
          ),
        ),
      ),
    );
  }

  Widget _categorySelector() {
    return Container();
  }

  Widget _locationTextField() {
    return Container();
  }

  Widget _datePicker() {
    return Container();
  }

  Widget _contentTextField() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        _categorySelector(),
                        _locationTextField(),
                        _datePicker(),
                        _contentTextField(),
                      ],
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
