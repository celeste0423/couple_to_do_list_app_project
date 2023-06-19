import 'package:carousel_slider/carousel_slider.dart';
import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/features/home/controller/diary_page_controller.dart';
import 'package:couple_to_do_list_app/features/upload_diary/pages/upload_diary_page.dart';
import 'package:couple_to_do_list_app/models/diary_model.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:couple_to_do_list_app/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ReadDiaryPage extends StatefulWidget {
  @override
  State<ReadDiaryPage> createState() => _ReadDiaryPageState();
}

class _ReadDiaryPageState extends State<ReadDiaryPage> {
  int activeIndex = 0;
  final DiaryModel selectedDiaryModel = Get.arguments;
  int? tabIndex;
  String? myNickname;
  String? bukkungNickname;
  String? mySogam;
  String? bukkungSogam;

  getSogam() {
    if (AuthController.to.user.value.uid == selectedDiaryModel.creatorUserID) {
      mySogam = selectedDiaryModel.creatorSogam;
      bukkungSogam = selectedDiaryModel.bukkungSogam;
    } else {
      bukkungSogam = selectedDiaryModel.creatorSogam;
      mySogam = selectedDiaryModel.bukkungSogam;
    }
  }

  getNickname() {
    myNickname = AuthController.to.user.value.nickname;
    if (AuthController.to.user.value.gender == 'male') {
      bukkungNickname = DiaryPageController.to.femaleNickname.value;
    } else {
      bukkungNickname = DiaryPageController.to.maleNickname.value;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabIndex = 0;
    getSogam();
    getNickname();
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

  Widget _divider() {
    return Divider(
      thickness: 2,
      color: CustomColors.mainPink,
    );
  }

  Widget _animatedSmoothIndicator() {
    if (selectedDiaryModel.imgUrlList!.isEmpty ||
        selectedDiaryModel.imgUrlList!.length == 1) {
      return SizedBox(
        height: 20,
      );
    } else {
      return AnimatedSmoothIndicator(
          activeIndex: activeIndex,
          count: selectedDiaryModel.imgUrlList!.length,
          effect: JumpingDotEffect(
            activeDotColor: CustomColors.redbrown,
            dotHeight: 8,
            dotWidth: 8,
          ));
    }
  }

  Widget _imgContainer() {
    double width = Get.width;
    if (selectedDiaryModel.imgUrlList!.isEmpty) {
      return Container(
        color: Colors.black,
        height: width - 60,
      );
    } else {
      return Expanded(
        child: CarouselSlider.builder(
          itemCount: selectedDiaryModel.imgUrlList!.length,
          itemBuilder: (ctx, index, realIndex) {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    selectedDiaryModel.imgUrlList![index],
                  ),
                ),
              ),
            );
          },
          options: CarouselOptions(
            onPageChanged: (index, reason) {
              setState(() {
                activeIndex = index;
              });
            },
            height: width - 60,
            viewportFraction: 1,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 6),
          ),
        ),
      );
    }
  }

  Widget _dateText(DateTime? date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          date != null ? DateFormat('yyyy-MM-dd').format(date) : '',
          style: TextStyle(fontSize: 20, color: CustomColors.greyText),
        ),
        SizedBox(
          width: 5,
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

  Widget _diaryTab(int index) {
    if (index == 0) {
      return SizedBox(
        height: 260,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  tabIndex = 1;
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
                        alignment: Alignment.topRight,
                        child: Text('$bukkungNickname 소감')),
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
                    child: Text('$myNickname 소감'))),
            Positioned(
              top: 35,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                height: 170,
                width: Get.width - 60,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    circleHolesColumn(),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      child: Text(
                        selectedDiaryModel.creatorSogam ?? '없음',
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
        ),
      );
    } else {
      return SizedBox(
        height: 260,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      tabIndex = 0;
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
                      child: Text('$myNickname 소감')),
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
                  child: Align(
                      alignment: Alignment.topRight,
                      child: Text('$bukkungNickname 소감')),
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
        ),
      );
    }
  }

  Widget _bottombuttons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
            onPressed: () {
              print('edit button');
              Get.off(() => UploadDiaryPage(), arguments: selectedDiaryModel);
            },
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _divider(),
            _animatedSmoothIndicator(),
            _imgContainer(),
            SizedBox(
              height: 5,
            ),
            _dateText(selectedDiaryModel.date),
            SizedBox(
              height: 5,
            ),
            _diaryTab(tabIndex!),
          ],
        ),
      ),
    );
  }
}
