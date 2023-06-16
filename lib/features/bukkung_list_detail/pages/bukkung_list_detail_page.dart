import 'package:couple_to_do_list_app/models/bukkung_list_model.dart';
import 'package:couple_to_do_list_app/utils/category_to_text.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:couple_to_do_list_app/widgets/category_icon.dart';
import 'package:couple_to_do_list_app/widgets/png_icons.dart';
import 'package:couple_to_do_list_app/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BukkungListDetailPage extends StatelessWidget {
  final BukkungListModel bukkungListModel;
  const BukkungListDetailPage({
    Key? key,
    required this.bukkungListModel,
  }) : super(key: key);

  PreferredSizeWidget _appBar() {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 35,
          ),
        ),
      ),
      title: TitleText(
        text: '상세보기',
      ),
      actions: [
        PopupMenuButton(
          offset: Offset(0, 50),
          shape: ShapeBorder.lerp(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            1,
          ),
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                onTap: () {},
                child: Text(
                  "수정하기",
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
          child: Icon(
            Icons.more_vert,
            size: 35,
          ),
        ),
      ],
    );
  }

  Widget _detailContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 30),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              children: [
                CategoryIcon(category: bukkungListModel.category!),
                SizedBox(width: 10),
                Text(
                  CategoryToText(bukkungListModel.category!),
                  style: TextStyle(
                    color: CustomColors.blackText,
                    fontSize: 25,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                bukkungListModel.title!,
                style: TextStyle(
                  color: CustomColors.blackText,
                  fontSize: 35,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, top: 10),
                child: Text(
                  bukkungListModel.date!.toString().substring(0, 10),
                  style: TextStyle(
                    color: CustomColors.greyText,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, bottom: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                bottomLeft: Radius.circular(50),
              ),
              child: Image.network(
                bukkungListModel.imgUrl!,
                height: 300,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Row(
            children: [
              Row(
                children: [
                  PngIcon(iconName: 'location-pin'),
                  Text(
                    bukkungListModel.location!,
                    style: TextStyle(
                      color: CustomColors.blackText,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                bukkungListModel.content!,
                style: TextStyle(
                  color: CustomColors.blackText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          width: 140,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: CustomColors.mainPink,
          ),
          child: Center(
            child: Text(
              '리스트 완료',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _detailContent(),
      bottomNavigationBar: _bottomBar(),
    );
  }
}
