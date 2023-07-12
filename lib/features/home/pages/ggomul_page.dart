import 'package:couple_to_do_list_app/features/home/controller/ggomul_page_controller.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:couple_to_do_list_app/widgets/text/PcText.dart';
import 'package:couple_to_do_list_app/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GgomulPage extends GetView<GgomulPageController> {
  const GgomulPage({Key? key}) : super(key: key);

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: CustomColors.lightPink,
      title: TitleText(
        text: '진척도',
      ),
    );
  }

  Widget _listCount() {
    return Column(
      children: [
        Text(
          '66%',
          style: TextStyle(
            fontSize: 15,
            color: CustomColors.blackText,
          ),
        ),
        Text(
          '(2/3)',
          style: TextStyle(
            fontSize: 12,
            color: CustomColors.darkGrey,
          ),
        ),
        Stack(
          children: [
            Container(
              height: 300,
              width: 25,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset(6, 2),
                    spreadRadius: 2,
                    blurRadius: 4,
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: AnimatedContainer(
                height: 210,
                width: 25,
                duration: Duration(milliseconds: 500),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      CustomColors.lightPink.withOpacity(0.8),
                      CustomColors.mainPink
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _ggomulCard() {
    return Container(
      height: 320,
      width: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, 5),
            spreadRadius: 2,
            blurRadius: 3,
          )
        ],
      ),
      child: Center(
        child: Container(
          height: 290,
          width: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              width: 2,
              color: CustomColors.lightPink,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PcText(
                '꼬물이',
                style: TextStyle(fontSize: 35),
              ),
              Text(
                '1단계',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Image.asset(
                'assets/images/ggomool.png',
                width: 130,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _completedList() {
    return Expanded(
      child: Container(
        width: 340,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(GgomulPageController());
    return Scaffold(
      backgroundColor: CustomColors.lightPink,
      appBar: _appBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _listCount(),
                _ggomulCard(),
              ],
            ),
          ),
          SizedBox(height: 30),
          _completedList(),
          SizedBox(height: 110),
        ],
      ),
    );
  }
}
