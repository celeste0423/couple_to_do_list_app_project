import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/features/home/controller/bukkung_list_controller.dart';
import 'package:couple_to_do_list_app/features/list_suggestion/pages/list_suggestion_page.dart';
import 'package:couple_to_do_list_app/helper/show_alert_dialog.dart';
import 'package:couple_to_do_list_app/models/bukkung_list_model.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BukkungListPage extends StatefulWidget {
  const BukkungListPage({Key? key}) : super(key: key);

  @override
  State<BukkungListPage> createState() => _BukkungListPageState();
}

class _BukkungListPageState extends State<BukkungListPage> {
  String? currentType;
  final Map<String, String> _typetoString = {
    "icon": "유형별로 보기",
    "date": "날짜순으로 보기",
    "like": "좋아요 순으로 보기",
  };

  @override
  void initState() {
    currentType = "icon";
    super.initState();
  }

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
            setState(() {
              currentType = listType;
            });
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                value: "icon",
                child: Text(
                  "유형별로 보기",
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
                  "날짜 순으로 보기",
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
                  "좋아요 순으로 보기",
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(_typetoString[currentType] ?? ""),
              Hero(
                tag: 'background',
                child: Icon(
                  Icons.arrow_drop_down,
                  color: CustomColors.mainPink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bukkungListView() {
    return Expanded(
      child: Obx(() {
        print('현재 타입 (buk page)${currentType!}');
        print('현재 그룹 (buk page)${AuthController.to.group.value.uid}');
        return StreamBuilder(
          stream: BukkungListController.to.getAllBukkungList(
            currentType!,
            AuthController.to.group.value,
          ),
          builder: (BuildContext context,
              AsyncSnapshot<List<BukkungListModel>> bukkungLists) {
            if (!bukkungLists.hasData) {
              return Center(
                child: CircularProgressIndicator(color: CustomColors.mainPink),
              );
            } else if (bukkungLists.hasError) {
              openAlertDialog(message: '에러 발생');
            } else {
              final _list = bukkungLists.data!;
              return ListView.builder(
                itemCount: _list.length,
                itemBuilder: (context, index) {
                  final _bukkungList = _list[index];
                  return Card(
                    child: ListTile(
                      title: Text(_bukkungList.title!),
                      subtitle: Text(_bukkungList.content!),
                    ),
                  );
                },
              );
            }
            return Center(child: Text('아직 버꿍리스트가 없습니다'));
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.backgroundLightGrey,
        title: Text('버꿍리스트'),
        actions: [
          IconButton(
            onPressed: () {
              openAlertDialog(message: '아직 설정창이 없습니다');
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Hero(
              tag: 'search_bar',
              child: Divider(
                thickness: 2,
                color: CustomColors.mainPink,
              ),
            ),
          ),
          _bukkungListView(),
        ],
      ),
    );
  }
}
