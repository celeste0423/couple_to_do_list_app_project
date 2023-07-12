import 'package:couple_to_do_list_app/binding/init_binding.dart';
import 'package:couple_to_do_list_app/features/home/pages/bukkung_list_page.dart';
import 'package:couple_to_do_list_app/features/home/pages/diary_page.dart';
import 'package:couple_to_do_list_app/features/home/pages/ggomul_page.dart';
import 'package:couple_to_do_list_app/features/home/pages/my_page.dart';
import 'package:couple_to_do_list_app/features/home/widgets/circle_tab_indicator.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 4, vsync: this);

  @override
  void initState() {
    super.initState();
    InitBinding.additionalBinding();
  }

  Widget _CustomTabBar() {
    return Container(
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
        indicator: CircleTabIndicator(
          color: Colors.white,
          radius: 12,
        ),
        controller: _tabController,
        indicatorWeight: 4,
        splashFactory: NoSplash.splashFactory,
        tabs: [
          Tab(
            child: Image.asset(
              'assets/icons/home.png',
              width: 50,
              color: _tabController.index == 0
                  ? Colors.white
                  : Colors.white.withOpacity(0.7),
              colorBlendMode: BlendMode.modulate,
            ),
          ),
          Tab(
            child: Image.asset(
              'assets/icons/note.png',
              width: 50,
              color: _tabController.index == 1
                  ? Colors.white
                  : Colors.white.withOpacity(0.7),
              colorBlendMode: BlendMode.modulate,
            ),
          ),
          Tab(
            child: Image.asset(
              'assets/icons/pets.png',
              width: 50,
              color: _tabController.index == 2
                  ? Colors.white
                  : Colors.white.withOpacity(0.7),
              colorBlendMode: BlendMode.modulate,
            ),
          ),
          Tab(
            child: Image.asset(
              'assets/icons/person.png',
              width: 50,
              color: _tabController.index == 3
                  ? Colors.white
                  : Colors.white.withOpacity(0.7),
              colorBlendMode: BlendMode.modulate,
            ),
          ),
        ],
        onTap: (index) {
          setState(() {});
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('(home page)홈페이지임');
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          BukkungListPage(),
          DiaryPageTest(),
          GgomulPage(),
          MyPage(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _CustomTabBar(),
    );
  }
}
