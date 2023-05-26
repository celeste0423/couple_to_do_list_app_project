import 'package:couple_to_do_list_app/features/list_suggestion/controller/list_suggestion_page_controller.dart';
import 'package:couple_to_do_list_app/features/upload_bukkung_list/pages/upload_bukkung_list_page.dart';
import 'package:couple_to_do_list_app/helper/show_alert_dialog.dart';
import 'package:couple_to_do_list_app/models/bukkung_list_model.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:couple_to_do_list_app/widgets/custom_icon_button.dart';
import 'package:couple_to_do_list_app/widgets/type_select_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListSuggestionPage extends GetView<ListSuggestionPageController> {
  const ListSuggestionPage({Key? key}) : super(key: key);

  Widget _background() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100)),
        color: CustomColors.mainPink,
      ),
      height: 350,
    );
  }

  Widget _searchBar() {
    return Hero(
      tag: 'search_bar',
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.white,
          ),
          height: 50,
          child: TextField(
            controller: controller.searchBarController,
            style: TextStyle(
              color: CustomColors.darkGrey,
              fontFamily: 'Yoonwoo',
              fontSize: 20,
            ),
            decoration: InputDecoration(
              hintText: '다양한 버꿍리스트를 찾아보세요',
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.search_rounded,
                size: 35,
                color: CustomColors.darkGrey,
              ),
              // prefixIcon: Image.asset(
              //   'assets/icons/search.png',
              //   color: Colors.white.withOpacity(0.7),
              //   colorBlendMode: BlendMode.modulate,
              // ),
              suffixIcon: controller.isTextEmpty
                  ? null
                  : IconButton(
                      icon: Icon(
                        Icons.close,
                        size: 20,
                        color: CustomColors.darkGrey,
                      ),
                      onPressed: () {
                        return controller.searchBarController.clear();
                      },
                    ),
            ),
          ),
          // child: Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: [
          //     Image.asset(
          //       'assets/icons/search.png',
          //       width: 30,
          //       color: Colors.white.withOpacity(0.7),
          //       colorBlendMode: BlendMode.modulate,
          //     ),
          //     SizedBox(width: 20),
          //     Text(
          //       '다양한 버꿍리스트를 찾아보세요',
          //       style: TextStyle(
          //         color: CustomColors.grey.withOpacity(0.5),
          //         fontSize: 20,
          //       ),
          //     ),
          //   ],
          // ),
        ),
      ),
    );
  }

  Widget _selectedImage() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      width: 330,
      height: 230,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 10,
            offset: Offset(5, 5), // Offset(수평, 수직)
          ),
        ],
        image: DecorationImage(
          image: NetworkImage(
            'https://post-phinf.pstatic.net/MjAxNzEwMjBfNjYg/MDAxNTA4NDY0NzkxMDc3.BXMDJ0jGbaunHr6TRI6N4NOBiGOXAlXbzlmgaZYHMkQg.P6Rbnq9YTv9CCqH5Vgu6JCSEGZC_wOZ25onOnoT4AAAg.PNG/11.png?type=w1200',
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _listPlayButton() {
    return Positioned(
      top: 350,
      left: Get.width / 2 - 35,
      child: Hero(
        tag: 'background',
        child: CustomIconButton(
          onTap: () {
            openAlertDialog(title: '아직 추천 페이지 없음');
          },
          size: 70,
          icon: Icon(
            Icons.play_arrow_rounded,
            size: 70,
            color: Colors.white,
          ),
          shadowOffset: Offset(5, 5),
          shadowBlurRadius: 5,
        ),
      ),
    );
  }

  Widget _suggestionListTab() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: TabBarView(
          controller: controller.suggestionListTabController,
          children: [
            _suggestionList(0),
            _suggestionList(1),
            _suggestionList(2),
            _suggestionList(3),
            _suggestionList(4),
            _suggestionList(5),
          ],
        ),
      ),
    );
  }

  Widget _suggestionList(int index) {
    print('탭별 리스트 로딩 (sug pag) 탭: $index}');
    return FutureBuilder(
      future: controller.getSuggestionBukkungList(
        controller.tabIndexToName(index),
      ),
      builder: (BuildContext context,
          AsyncSnapshot<List<BukkungListModel>> bukkungLists) {
        print(bukkungLists.hasData);
        if (!bukkungLists.hasData) {
          return Center(
            child: CircularProgressIndicator(color: CustomColors.mainPink),
          );
        } else if (bukkungLists.hasError) {
          openAlertDialog(title: '에러 발생');
        } else {
          final _list = bukkungLists.data!;
          print('리스트 출력(sugg page)${_list.length}');
          return ListView.builder(
            itemCount: _list.length,
            itemBuilder: (context, index) {
              final _bukkungList = _list[index];
              return _suggestionListCard(_bukkungList);
            },
          );
        }
        return Center(child: Text('아직 버꿍리스트가 없습니다'));
      },
    );
  }

  Widget _suggestionListCard(BukkungListModel bukkungListModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 2),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: Offset(5, 5), // Offset(수평, 수직)
                ),
              ],
              image: DecorationImage(
                image: NetworkImage(bukkungListModel.imgUrl!),
                fit: BoxFit.cover,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _listAddButton() {
    return ElevatedButton(
      onPressed: () {
        // Get.lazyPut<UploadBukkungListController>(
        //     () => UploadBukkungListController(context: context),
        //     fenix: true);
        Get.to(() => UploadBukkungListPage());
      },
      style: ElevatedButton.styleFrom(
        fixedSize: Size(260, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/icons/plus.png',
            width: 30,
            color: Colors.black.withOpacity(0.5),
            colorBlendMode: BlendMode.modulate,
          ),
          SizedBox(width: 10),
          Text(
            '리스트 새로 만들기',
            style: TextStyle(
              color: Colors.black.withOpacity(0.5),
              fontSize: 30,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ListSuggestionPageController());
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: CustomColors.mainPink,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
          ),
          title: Text(
            '추천 리스트',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: Stack(
          children: [
            _background(),
            Column(
              children: [
                _searchBar(),
                categorySelectTabBar(
                  controller.suggestionListTabController,
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.5),
                ),
                _selectedImage(),
                _suggestionListTab(),
              ],
            ),
            _listPlayButton(),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _listAddButton(),
      ),
    );
  }
}
