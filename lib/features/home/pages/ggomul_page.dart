import 'dart:ui';

import 'package:couple_to_do_list_app/features/home/controller/ggomul_page_controller.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:couple_to_do_list_app/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GgomulPage extends GetView<GgomulPageController> {
  const GgomulPage({Key? key}) : super(key: key);

  PreferredSizeWidget _appBar() {
    return AppBar(
      title: TitleText(
        text: '진척도',
      ),
    );
  }

  Widget _listCount() {
    return Column(
      children: [
        Text('66%'),
        Text('(2/3)'),
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
                    offset: Offset(5, 5),
                    spreadRadius: 5,
                  )
                ],
              ),
            ),
            AnimatedContainer(
              height: 210,
              width: 25,
              duration: Duration(milliseconds: 500),
              decoration: BoxDecoration(
                // gradient: Gradient.linear(from, to, colors),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset(5, 5),
                    spreadRadius: 5,
                  )
                ],
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
            offset: Offset(5, 5),
            spreadRadius: 2,
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
              width: 1,
              color: CustomColors.lightPink,
            ),

          ),
        ),
      ),
    );
  }

  Widget _completedList() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(GgomulPageController());
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          Row(
            children: [
              _listCount(),
              _ggomulCard(),
            ],
          ),
          _completedList(),
        ],
      ),
    );
  }
}
