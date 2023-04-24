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
          height: 75,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: CustomColors.mainPink,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.7),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, -3), // Offset(수평, 수직)
              ),
            ],
          ),
          child: TabBar(
              indicatorWeight: 4,
              splashFactory: NoSplash.splashFactory,
              tabs: [
                //아이콘은 잠깐 다 임시로
                //Todo: 아이콘 파일 svg로 뽑아서 전부 교체할 것
                InkWell(child: Tab(icon: Image.asset('assets/icons/home.png'))),
                Tab(icon: Image.asset('assets/icons/note.png')),
                Tab(icon: Image.asset('assets/icons/pets.png')),
                Tab(icon: Image.asset('assets/icons/person.png')),
              ]),
        ),
      ),
    );
  }
}
