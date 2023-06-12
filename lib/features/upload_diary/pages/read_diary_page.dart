import 'package:couple_to_do_list_app/models/diary_model.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:couple_to_do_list_app/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReadDiaryPage extends StatefulWidget {
  @override
  State<ReadDiaryPage> createState() => _ReadDiaryPageState();
}

class _ReadDiaryPageState extends State<ReadDiaryPage> {
  final DiaryModel selectedDiaryModel = Get.arguments;
  int? i;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    i = 0;
  }

  PreferredSizeWidget _customAppBar(String? title) {
    return AppBar(
      backgroundColor: CustomColors.backgroundLightGrey,
      title: TitleText(text: title ?? ''),
      leading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: CustomColors.mainPink,
        ),
      ),
    );
  }

  Widget _Divider() {
    return Divider(
      thickness: 2,
      color: CustomColors.mainPink,
    );
  }

  Widget _ImgContainer() {
    return Container(
      color: Colors.black,
      height: Get.width - 60,
    );
  }

  Widget _DateText(DateTime? date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          date != null ? date.toString() : '2021-01-02',
          style: TextStyle(fontSize: 20, color: CustomColors.greyText),
        ),
        SizedBox(
          width: 10,
        )
      ],
    );
  }

  Widget circleHolesColumn() {
    double holediameter = 13;
    circleHole() {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        width: holediameter,
        height: holediameter,
        decoration: BoxDecoration(
          color: Color(0xffECE2E1),
          shape: BoxShape.circle,
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        circleHole(),
        circleHole(),
        circleHole(),
        circleHole(),
      ],
    );
  }

  Widget _DiaryTab(int index) {
    if (index == 0) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                i = 1;
              });
            },
            child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 40),
                  decoration: BoxDecoration(
                      color: CustomColors.lightPink,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(700),
                          topRight: Radius.circular(30))),
                  width: Get.width * 15 / 32,
                  height: 45,
                  child: Align(
                      alignment: Alignment.topRight, child: Text('짝꿍 소감')),
                )),
          ),
          Align(
              alignment: Alignment.topLeft,
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 40),
                  decoration: BoxDecoration(
                      color: CustomColors.mainPink,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(700))),
                  width: Get.width * 15 / 32,
                  height: 45,
                  child: Text('나의 소감'))),
          Positioned(
            top: 35,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              height: 170,
              width: Get.width - 60,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  circleHolesColumn(),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: Text(
                      selectedDiaryModel.mySogam ?? '없음',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: CustomColors.greyText),
                    ),
                  )
                ],
              ),
            ),
          ),
          //top+height 하면 됨
          Positioned(right: 0, top: 205, child: _bottombuttons())
        ],
      );
    } else {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    i = 0;
                  });
                },
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 40),
                    decoration: BoxDecoration(
                        color: CustomColors.mainPink,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(700))),
                    width: Get.width * 15 / 32,
                    height: 45,
                    child: Text('나의 소감')),
              )),
          Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 40),
                decoration: BoxDecoration(
                    color: CustomColors.lightPink,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(700),
                        topRight: Radius.circular(30))),
                width: Get.width * 15 / 32,
                height: 45,
                child:
                    Align(alignment: Alignment.topRight, child: Text('짝꿍 소감')),
              )),
          Positioned(
            top: 35,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              height: 170,
              width: Get.width - 60,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  circleHolesColumn(),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: Text(
                      selectedDiaryModel.bukkungSogam ?? '없음',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: CustomColors.greyText),
                    ),
                  )
                ],
              ),
            ),
          ),
          //top+height 하면 됨
          Positioned(right: 0, top: 205, child: _bottombuttons())
        ],
      );
    }
  }

  Widget _bottombuttons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
            onPressed: () {},
            icon: Icon(Icons.edit, size: 25, color: CustomColors.lightPink)),
        IconButton(
            onPressed: () {},
            icon: Icon(Icons.share, size: 25, color: CustomColors.lightPink)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _customAppBar(selectedDiaryModel.title),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            _Divider(),
            SizedBox(
              height: 20,
            ),
            _ImgContainer(),
            SizedBox(
              height: 5,
            ),
            _DateText(selectedDiaryModel.date),
            SizedBox(
              height: 5,
            ),
            _DiaryTab(i!),
          ],
        ),
      ),
    );
  }
}
