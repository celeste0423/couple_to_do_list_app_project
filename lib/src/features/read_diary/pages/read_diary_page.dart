import 'package:carousel_slider/carousel_slider.dart';
import 'package:couple_to_do_list_app/src/features/read_diary/controller/read_diary_page_controller.dart';
import 'package:couple_to_do_list_app/src/utils/custom_color.dart';
import 'package:couple_to_do_list_app/src/widgets/custom_cached_networkImage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ReadDiaryPage extends GetView<ReadDiaryPageController> {
  const ReadDiaryPage({Key? key}) : super(key: key);

  PreferredSizeWidget _customAppBar(String? title) {
    return AppBar(
      backgroundColor: CustomColors.backgroundLightGrey,
      title: Text(title ?? ''),
      leading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: CustomColors.mainPink,
          size: 30,
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
    return Visibility(
      visible: controller.selectedDiaryModel.imgUrlList!.isNotEmpty &&
          controller.selectedDiaryModel.imgUrlList!.length != 1,
      child: Obx(
        () => AnimatedSmoothIndicator(
          activeIndex: controller.activeIndex.value,
          count: controller.selectedDiaryModel.imgUrlList!.length,
          effect: JumpingDotEffect(
            activeDotColor: CustomColors.black,
            dotHeight: 8,
            dotWidth: 8,
          ),
        ),
      ),
    );
  }

  Widget _imgContainer() {
    double width = Get.width;
    if (controller.selectedDiaryModel.imgUrlList!.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/baseimage_ggomool.png'),
            fit: BoxFit.cover,
          ),
        ),
        height: width - 60,
      );
    } else if (controller.selectedDiaryModel.imgUrlList!.length == 1) {
      return Expanded(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CustomCachedNetworkImage(
                  controller.selectedDiaryModel.imgUrlList![0]),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    } else {
      return Expanded(
        child: CarouselSlider.builder(
          itemCount: controller.selectedDiaryModel.imgUrlList!.length,
          itemBuilder: (ctx, index, realIndex) {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CustomCachedNetworkImage(
                      controller.selectedDiaryModel.imgUrlList![index]),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
          options: CarouselOptions(
            onPageChanged: (index, reason) {
              controller.setActiveIndex(index);
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
          style: TextStyle(fontSize: 15, color: CustomColors.greyText),
        ),
        SizedBox(width: 5),
      ],
    );
  }

  Widget _circleHolesColumn() {
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

  Widget _myCommentSection() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: () {
            controller.tabViewButton();
          },
          child: Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 40),
              decoration: BoxDecoration(
                color: CustomColors.lightPink,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(700),
                  topRight: Radius.circular(30),
                ),
              ),
              width: Get.width * 15 / 32,
              height: 45,
              child: Align(
                alignment: Alignment.topRight,
                child: Text('${controller.buddyNickname} 소감'),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 40),
            decoration: BoxDecoration(
              color: CustomColors.mainPink,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(700),
              ),
            ),
            width: Get.width * 15 / 32,
            height: 45,
            child: Text('${controller.myNickname} 소감'),
          ),
        ),
        Positioned(
          top: 35,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            height: 170,
            width: Get.width - 60,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _circleHolesColumn(),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: controller.myComment != null
                        ? Text(
                            controller.myComment!,
                            style: TextStyle(color: CustomColors.greyText),
                          )
                        : GestureDetector(
                            onTap: () async {
                              await Get.toNamed('/writeDiary');
                            },
                            child: Text(
                              '이야기를 작성해주세요',
                              style: TextStyle(color: CustomColors.greyText),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buddyCommentSection() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: () {
            controller.tabViewButton();
          },
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 40),
              decoration: BoxDecoration(
                color: CustomColors.mainPink,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(700),
                ),
              ),
              width: Get.width * 15 / 32,
              height: 45,
              child: Align(
                alignment: Alignment.topLeft,
                child: Text('${controller.myNickname} 소감'),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 40),
            decoration: BoxDecoration(
              color: CustomColors.lightPink,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(700),
                topRight: Radius.circular(30),
              ),
            ),
            width: Get.width * 15 / 32,
            height: 45,
            child: Text('${controller.buddyNickname} 소감'),
          ),
        ),
        Positioned(
          top: 35,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            height: 170,
            width: Get.width - 60,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _circleHolesColumn(),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: controller.buddyComment != null
                        ? Text(
                            controller.buddyComment!,
                            style: TextStyle(color: CustomColors.greyText),
                          )
                        : GestureDetector(
                            onTap: () async {
                              await Get.toNamed('/writeDiary');
                            },
                            child: Text(
                              '이야기를 작성해주세요',
                              style: TextStyle(color: CustomColors.greyText),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _diaryTabView() {
    return SizedBox(
      height: 260,
      child: Obx(
        () => controller.isMyComment.value
            ? _myCommentSection()
            : _buddyCommentSection(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ReadDiaryPageController());
    return Scaffold(
      appBar: _customAppBar(controller.selectedDiaryModel.title),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _divider(),
            _animatedSmoothIndicator(),
            _imgContainer(),
            SizedBox(height: 10),
            _dateText(controller.selectedDiaryModel.date),
            SizedBox(height: 10),
            _diaryTabView(),
          ],
        ),
      ),
    );
  }
}
