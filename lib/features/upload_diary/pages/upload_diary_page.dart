import 'package:couple_to_do_list_app/features/upload_diary/controller/upload_diary_controller.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:couple_to_do_list_app/widgets/auxiliary_button.dart';
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
          prefixIcon:  Icon(
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

  Widget _contentTextField() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
        //Todo: 이거 수정해야될듯 높이
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Divider(
              color: Colors.black,
            ),
            TextField(
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
                  borderSide: BorderSide(color: Colors.redAccent), //<-- SEE HERE
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
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(UploadDiaryController());
    return GestureDetector(
      onTap:(){ FocusManager.instance.primaryFocus?.unfocus();},
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: CustomColors.lightPink,
        body: Column(
          children: [
            SizedBox(height: 10,),
            _Title(),
            _contentTextField(),
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
