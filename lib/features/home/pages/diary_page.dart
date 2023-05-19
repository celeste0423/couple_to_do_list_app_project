import 'package:couple_to_do_list_app/features/upload_diary/pages/upload_diary_page.dart';
import 'package:couple_to_do_list_app/widgets/custom_icon_button.dart';
import 'package:couple_to_do_list_app/widgets/title_text.dart';
import 'package:couple_to_do_list_app/widgets/type_select_tab_bar.dart';
import 'package:couple_to_do_list_app/helper/show_alert_dialog.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({Key? key}) : super(key: key);

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabDiaryController =
      TabController(length: 6, vsync: this);

  //ToDo: 파이어베이스에서 가져온 정보로 채워 넣을 것
  Widget _diary() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Stack(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RotatedBox(
                quarterTurns: 135,
                child: Text(
                  '돼지길동🤍꼬물꼬물 다이어리',
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.4), fontSize: 25),
                ),
              ),
              Container(
                width: 230,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: Offset(15, 15), // Offset(수평, 수직)
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      '제주도 여행',
                      style: TextStyle(fontSize: 35),
                    ),
                    Container(
                      width: 170,
                      height: 170,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://post-phinf.pstatic.net/MjAxNzEwMjBfNjYg/MDAxNTA4NDY0NzkxMDc3.BXMDJ0jGbaunHr6TRI6N4NOBiGOXAlXbzlmgaZYHMkQg.P6Rbnq9YTv9CCqH5Vgu6JCSEGZC_wOZ25onOnoT4AAAg.PNG/11.png?type=w1200',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),

                      //사진이 없을경우 기본 이미지 꼬물이로
                      // child: Image.asset(
                      //   'assets/images/ggomool.png',
                      //   width: 170,
                      //   height: 170,
                      // ),
                    ),
                    Text(
                      '2023.04.05 ~ 2023.04.08',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
              top: 130,
              right: 50,
              child: CustomIconButton(
                onTap: () {
                  openAlertDialog(
                    title: '아직 다이어리 페이지 없음 ㅎ',
                  );
                },
              )),
        ],
      ),
    );
  }

  Widget _diaryList() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: CustomColors.backgroundLightGrey,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(50),
            topLeft: Radius.circular(50),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              //Todo: 색상 입력 안해도 되도록 기본값 넣어뒀는데도 오류가 발생하는 이유..?
              child: typeSelectTabBar(
                _tabDiaryController,
                CustomColors.darkGrey,
                CustomColors.grey.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.lightPink,
      appBar: AppBar(
        backgroundColor: CustomColors.lightPink,
        title: Text(
          '다이어리',
          style: TextStyle(color: Colors.black.withOpacity(0.6)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              onPressed: () {
               Get.to(()=>UploadDiaryPage(null, null, null));
              },
              icon: Image.asset(
                'assets/icons/plus.png',
                color: CustomColors.darkGrey.withOpacity(0.7),
                colorBlendMode: BlendMode.modulate,
                width: 35,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _diary(),
          _diaryList(),
        ],
      ),
    );
  }
}
