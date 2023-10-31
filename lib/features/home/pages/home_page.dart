import 'package:couple_to_do_list_app/features/home/controller/bukkung_list_page_controller.dart';
import 'package:couple_to_do_list_app/features/home/pages/bukkung_list_page.dart';
import 'package:couple_to_do_list_app/features/home/pages/diary_page.dart';
import 'package:couple_to_do_list_app/features/home/pages/ggomul_page.dart';
import 'package:couple_to_do_list_app/features/home/pages/my_page.dart';
import 'package:couple_to_do_list_app/features/home/widgets/circle_tab_indicator.dart';
import 'package:couple_to_do_list_app/features/tutorial_coach_mark/pages/coachmark_desc.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TutorialCoachMark? tutorialCoachMark;
  List<TargetFocus> targets = [];

  GlobalKey bukkungTabKey = GlobalKey();
  GlobalKey diaryTabKey = GlobalKey();
  GlobalKey ggomulTabKey = GlobalKey();
  GlobalKey myTabKey = GlobalKey();

  late final TabController _tabController =
      TabController(length: 4, vsync: this);

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      _showTutorialCoachMark();
    });
    // InitBinding.additionalBinding();
  }

  void _showTutorialCoachMark() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasShownTutorial = prefs.getBool('hasShownTutorial') ?? false;
    if (hasShownTutorial) {
      //이미 튜토리얼을 진행했으면 튜토리얼 종료
      return;
    }
    _initTarget(); //타겟 더하기
    tutorialCoachMark = TutorialCoachMark(
        targets: targets, hideSkip: true, onClickTarget: (target) {})
      ..show(context: context);
    await prefs.setBool('hasShownTutorial', true);
  }

  void _initTarget() {
    targets = [
      TargetFocus(
        identify: "list_suggestion_key",
        keyTarget: BukkungListPageController.to.listSuggestionKey,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return CoachmarkDesc(
                text: "여기서 버꿍리스트를 새로 만들거나 추천 버꿍리스트를 가져올 수 있습니다",
                onNext: () {
                  controller.next();
                },
                onSkip: () {
                  controller.skip();
                },
              );
            },
          )
        ],
      ),
      TargetFocus(
        identify: "bukkung-list-key",
        keyTarget: BukkungListPageController.to.bukkungListKey,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                text: "짝꿍과의 버꿍리스트를 확인하세요",
                onNext: () {
                  controller.next();
                },
                onSkip: () {
                  controller.skip();
                },
              );
            },
          )
        ],
      ),
      TargetFocus(
        identify: "diary-tab-key",
        keyTarget: diaryTabKey,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return CoachmarkDesc(
                text: "완료한 버꿍리스트는 여기 다이어리탭에 서로의 소감과 함께 저장할 수 있습니다",
                onNext: () {
                  controller.next();
                },
                onSkip: () {
                  controller.skip();
                },
              );
            },
          )
        ],
      ),
      // TargetFocus(
      //   identify: "bukkung-tab-key",
      //   keyTarget: bukkungTabKey,
      //   contents: [
      //     TargetContent(
      //       align: ContentAlign.top,
      //       builder: (context, controller) {
      //         return CoachmarkDesc(
      //           text: "여기서 짝꿍과의 버꿍리스트를 확인하세요",
      //           onNext: () {
      //             controller.next();
      //           },
      //           onSkip: () {
      //             controller.skip();
      //           },
      //         );
      //       },
      //     )
      //   ],
      // ),
    ];
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
            key: bukkungTabKey,
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
            key: diaryTabKey,
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
            key: ggomulTabKey,
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
            key: myTabKey,
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
    // print('(home page)홈페이지임');
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(),
        children: const [
          BukkungListPage(),
          DiaryPage(),
          GgomulPage(),
          MyPage(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _CustomTabBar(),
    );
  }
}
