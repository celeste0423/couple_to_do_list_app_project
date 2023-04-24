import 'package:couple_to_do_list_app/helper/show_alert_dialog.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/material.dart';

class BukkungListPage extends StatefulWidget {
  const BukkungListPage({Key? key}) : super(key: key);

  @override
  State<BukkungListPage> createState() => _BukkungListPageState();
}

class _BukkungListPageState extends State<BukkungListPage> {
  String? currentType;
  final Map<String, String> TypetoString = {
    "icon": "유형별로 보기",
    "date": "날짜순으로 보기",
    "like": "좋아요 순으로 보기",
  };

  @override
  void initState() {
    currentType = "icon";
    super.initState();
  }

  Widget _ListAddButton() {
    return GestureDetector(
      onTap: () {
        showAlertDialog(context: context, message: '아직 페이지가 없습니다..');
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
            Text(
              '여기를 눌러 버꿍리스트를 추가하세요',
              style: TextStyle(
                color: CustomColors.grey.withOpacity(0.5),
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ListTypeSelector() {
    return Container(
      width: 150,
      child: PopupMenuButton<String>(
        offset: Offset(0, 40),
        shape: ShapeBorder.lerp(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          1,
        ),
        onSelected: (String type) {
          setState(() {
            currentType = type;
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
            Text(TypetoString[currentType] ?? ""),
            Icon(
              Icons.arrow_drop_down,
              color: CustomColors.mainPink,
            ),
          ],
        ),
      ),
    );
  }

  Widget _BukkungListView() {
    return Container();
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
              showAlertDialog(context: context, message: '아직 설정창이 없습니다');
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
          _ListAddButton(),
          _ListTypeSelector(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              thickness: 2,
              color: CustomColors.mainPink,
            ),
          ),
          _BukkungListView(),
        ],
      ),
    );
  }
}
