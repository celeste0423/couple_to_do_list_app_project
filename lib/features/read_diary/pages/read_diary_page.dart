import 'package:carousel_slider/carousel_slider.dart';
import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/features/upload_diary/pages/upload_diary_page.dart';
import 'package:couple_to_do_list_app/helper/background_message/controller/fcm_controller.dart';
import 'package:couple_to_do_list_app/models/diary_model.dart';
import 'package:couple_to_do_list_app/models/user_model.dart';
import 'package:couple_to_do_list_app/repository/user_repository.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:couple_to_do_list_app/widgets/custom_cached_networkImage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ReadDiaryPage extends StatefulWidget {
  const ReadDiaryPage({super.key});

  @override
  State<ReadDiaryPage> createState() => _ReadDiaryPageState();
}

class _ReadDiaryPageState extends State<ReadDiaryPage> {
  int activeIndex = 0;
  final DiaryModel selectedDiaryModel = Get.arguments;
  int? tabIndex;
  String? myNickname;
  String? buddyNickname;
  String? myComment;
  String? bukkungComment;

  getSogam() {
    if (AuthController.to.user.value.uid == selectedDiaryModel.creatorUserID) {
      myComment = selectedDiaryModel.creatorSogam;
      bukkungComment = selectedDiaryModel.bukkungSogam;
    } else {
      bukkungComment = selectedDiaryModel.creatorSogam;
      myComment = selectedDiaryModel.bukkungSogam;
    }
  }

  // Future<void> getNickname() async{
  //   myNickname = AuthController.to.user.value.nickname;
  //   if (AuthController.to.user.value.gender == 'male') {
  //     buddyNickname = DiaryPageController.to.femaleNickname.value;
  //   } else {
  //     buddyNickname = DiaryPageController.to.maleNickname.value;
  //   }
  //   print('짝꿍 닉네임 = ${buddyNickname}');
  // }

  Future<void> getNickname() async {
    if (AuthController.to.user.value.gender == 'male') {
      UserModel? buddyData = await UserRepository.getUserDataByUid(
          AuthController.to.group.value.femaleUid!);
      myNickname = AuthController.to.user.value.nickname;
      buddyNickname = buddyData!.nickname;
    } else {
      UserModel? buddyData = await UserRepository.getUserDataByUid(
          AuthController.to.group.value.maleUid!);
      myNickname = AuthController.to.user.value.nickname;
      buddyNickname = buddyData!.nickname;
    }
    print('짝꿍 닉네임 $buddyNickname');
  }

  Future<void> sendCompletedMessageToBuddy() async {
    final buddyUid = AuthController.to.user.value.gender == 'male'
        ? AuthController.to.group.value.femaleUid
        : AuthController.to.group.value.maleUid;
    print('짝꿍 uid $buddyUid');
    final userTokenData = await FCMController().getDeviceTokenByUid(buddyUid!);
    if (userTokenData != null) {
      print('유저 토큰 존재');
      FCMController().sendMessageController(
        userToken: userTokenData.deviceToken!,
        platform: userTokenData.platform,
        title: "${AuthController.to.user.value.nickname}님이 다이어리 소감 작성을 요청했어요!",
        body: '지금 바로 작성해보세요',
        dataType: 'diary',
        dataContent: selectedDiaryModel.diaryId,
      );
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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/baseimage_ggomool.png'),
            // this will be either NetworkImage or AssetImage, depending on whether the network image loaded
            fit: BoxFit.cover,
          ),
        ),
        height: width - 60,
      );
    } else if (selectedDiaryModel.imgUrlList!.length == 1) {
      return Expanded(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image:
                  CustomCachedNetworkImage(selectedDiaryModel.imgUrlList![0]),
              // this will be either NetworkImage or AssetImage, depending on whether the network image loaded
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    } else {
      return Expanded(
        child: CarouselSlider.builder(
          itemCount: selectedDiaryModel.imgUrlList!.length,
          itemBuilder: (ctx, index, realIndex) {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CustomCachedNetworkImage(
                      selectedDiaryModel.imgUrlList![index]),
                  // this will be either NetworkImage or AssetImage, depending on whether the network image loaded
                  fit: BoxFit.cover,
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
          style: TextStyle(fontSize: 15, color: CustomColors.greyText),
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
                        child: Text('$buddyNickname 소감')),
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
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        child: myComment != null
                            ? Text(
                                myComment!,
                                style: TextStyle(color: CustomColors.greyText),
                              )
                            : GestureDetector(
                                onTap: () {
                                  Get.off(() => UploadDiaryPage(),
                                      arguments: selectedDiaryModel);
                                },
                                child: Text(
                                  '여기를 눌러 소감을 작성하세요',
                                  style: TextStyle(
                                    color: CustomColors.greyText,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            //top+height 하면 됨
            Positioned(
              right: 0,
              top: 205,
              child: _bottomButtons(),
            )
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
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 40),
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
                      child: Text('$buddyNickname 소감')),
                )),
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
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        child: bukkungComment != null
                            ? Text(
                                bukkungComment!,
                                style: TextStyle(color: CustomColors.greyText),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  await sendCompletedMessageToBuddy();
                                  Get.snackbar('전송완료', '요청을 보냈습니다.');
                                },
                                child: Text(
                                  '아직 상대가 소감을 작성하지 않았어요. \n여기를 눌러 소감 작성을 요청해보세요.',
                                  style: TextStyle(
                                    color: CustomColors.greyText,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //top+height 하면 됨
            Positioned(right: 0, top: 205, child: _bottomButtons())
          ],
        ),
      );
    }
  }

  Widget _bottomButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
            onPressed: () {
              Get.off(() => UploadDiaryPage(), arguments: selectedDiaryModel);
            },
            icon: Icon(Icons.edit, size: 25, color: CustomColors.lightPink)),
        // IconButton(
        //     onPressed: () {},
        //     icon: Icon(Icons.share, size: 25, color: CustomColors.lightPink)),
        // IconButton(
        //     onPressed: () {},
        //     icon: Icon(Icons.delete, size: 30, color: CustomColors.lightPink)),
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
            FutureBuilder(
              future: getNickname(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return _diaryTab(tabIndex!);
                } else {
                  return _diaryTab(tabIndex!);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
