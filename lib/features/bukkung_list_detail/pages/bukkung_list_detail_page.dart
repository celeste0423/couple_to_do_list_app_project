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
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              bukkungListModel.title!,
              style: TextStyle(
                color: CustomColors.blackText,
                fontSize: 35,
              ),
            ),
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
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bottomBar() {
    return Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.edit_outlined),
        ),
      ],
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
