import 'package:couple_to_do_list_app/features/home/controller/bukkung_list_page_controller.dart';
import 'package:couple_to_do_list_app/features/home/pages/setting_page.dart';
import 'package:couple_to_do_list_app/features/list_suggestion/pages/list_suggestion_page.dart';
import 'package:couple_to_do_list_app/helper/show_alert_dialog.dart';
import 'package:couple_to_do_list_app/models/bukkung_list_model.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:couple_to_do_list_app/utils/type_to_color.dart';
import 'package:couple_to_do_list_app/widgets/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BukkungListPage extends GetView<BukkungListPageController> {
  const BukkungListPage({Key? key}) : super(key: key);

  Widget _listAddButton() {
    return GestureDetector(
      onTap: () {
        //Todo: route로 파일 뽑아낼 것
        Get.to(() => ListSuggestionPage());
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/icons/plus.png',
              width: 30,
              color: Colors.white.withOpacity(0.7),
              colorBlendMode: BlendMode.modulate,
            ),
            SizedBox(width: 20),
            Material(
              type: MaterialType.transparency,
              child: Text(
                '여기를 눌러 버꿍리스트를 추가하세요',
                style: TextStyle(
                  color: CustomColors.grey.withOpacity(0.5),
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listTypeSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: 150,
        child: PopupMenuButton<String>(
          offset: Offset(0, 40),
          shape: ShapeBorder.lerp(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            1,
          ),
          onSelected: (String listType) {
            controller.currentType.value = listType;
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                value: "icon",
                child: Text(
                  "유형별",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Yoonwoo',
                    letterSpacing: 1.5,
                    color: CustomColors.darkGrey,
                  ),
                ),
              ),
              PopupMenuItem(
                value: "date",
                child: Text(
                  "날짜 순",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Yoonwoo',
                    letterSpacing: 1.5,
                    color: CustomColors.darkGrey,
                  ),
                ),
              ),
              PopupMenuItem(
                value: "like",
                child: Text(
                  "좋아요 순",
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
          child: Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(controller.typetoString[controller.currentType.value] ??
                    ""),
                Hero(
                  tag: 'background',
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: CustomColors.mainPink,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _bukkungListView() {
    print('현재 타입 (buk page)${controller.currentType!.value}');
    return Expanded(
      child: StreamBuilder(
        stream: BukkungListPageController.to.getAllBukkungList(
          controller.currentType.value!,
        ),
        builder: (BuildContext context,
            AsyncSnapshot<List<BukkungListModel>> bukkungLists) {
          if (!bukkungLists.hasData) {
            print('로딩중(buk page');
            return Center(
              child: CircularProgressIndicator(color: CustomColors.mainPink),
            );
          } else if (bukkungLists.hasError) {
            openAlertDialog(message: '에러 발생');
          } else {
            final _list = bukkungLists.data!;
            print('리스트 출력(buk page)${_list.length}');
            return ListView.builder(
              itemCount: _list.length,
              itemBuilder: (context, index) {
                final _bukkungList = _list[index];
                print(_bukkungList.title);
                return _bukkungListCard(_bukkungList);
              },
            );
          }
          return Center(child: Text('아직 버꿍리스트가 없습니다'));
        },
      ),
    );
  }

  Widget _bukkungListCard(BukkungListModel bukkungListModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        children: [
          Expanded(
            flex: 9,
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  bottomLeft: Radius.circular(25),
                ),
              ),
              child: ListTile(
                title: Text(bukkungListModel.title!),
                subtitle: Text(bukkungListModel.content!),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                color: TypeToColor.typeToColor(bukkungListModel.category),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              width: 30,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    //Get.put(BukkungListPageController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.backgroundLightGrey,
        title: Text('버꿍리스트'),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(SettingsPage());
            },
            icon: Image.asset(
              'assets/icons/setting.png',
              color: Colors.white.withOpacity(0.7),
              colorBlendMode: BlendMode.modulate,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _listAddButton(),
          _listTypeSelector(),
          Hero(
            tag: 'search_bar',
            child: customDivider(),
          ),
          _bukkungListView(),
        ],
      ),
    );
  }
}
