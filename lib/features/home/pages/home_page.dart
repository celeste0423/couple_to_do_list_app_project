import 'package:couple_to_do_list_app/features/home/pages/bukkung_list_page.dart';
import 'package:couple_to_do_list_app/features/home/pages/diary_page.dart';
import 'package:couple_to_do_list_app/features/home/pages/kkomul_page.dart';
import 'package:couple_to_do_list_app/features/home/pages/my_page.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:couple_to_do_list_app/widgets/title_text.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColors.backgroundLightGrey,
          title: titleText('버꿍리스트'),
          actions: [
            IconButton(
              onPressed: () {
                print('설정');
              },
              icon: Icon(Icons.settings),
            ),
          ],
        ),
        body: const TabBarView(
          children: [
            BukkungListPage(),
            DiaryPage(),
            KkomulPage(),
            MyPage(),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: CustomColors.mainPink,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 2), // Offset(수평, 수직)
              ),
            ],
          ),
          child: TabBar(
              indicatorWeight: 4,
              splashFactory: NoSplash.splashFactory,
              tabs: [
                //아이콘은 잠깐 다 임시로
                //Todo: 아이콘 파일 svg로 뽑아서 전부 교체할 것
                Tab(
                  icon: Icon(
                    Icons.home_filled,
                    color: Colors.white,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.document_scanner,
                    color: Colors.white,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.pets,
                    color: Colors.white,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
