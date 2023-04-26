import 'package:couple_to_do_list_app/helper/show_alert_dialog.dart';
import 'package:couple_to_do_list_app/widgets/custom_icon_button.dart';
import 'package:couple_to_do_list_app/widgets/type_select_tab_bar.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListSuggestionPage extends StatefulWidget {
  const ListSuggestionPage({Key? key}) : super(key: key);

  @override
  State<ListSuggestionPage> createState() => _ListSuggestionPageState();
}

class _ListSuggestionPageState extends State<ListSuggestionPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabSuggestionController =
      TabController(length: 6, vsync: this);

  TextEditingController _searchBarController = TextEditingController();
  bool _isTextEmpty = true;

  @override
  void initState() {
    super.initState();
    _searchBarController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _searchBarController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _isTextEmpty = _searchBarController.text.isEmpty;
    });
  }

  Widget _background() {
    return Hero(
      tag: 'addList',
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100)),
          color: CustomColors.mainPink,
        ),
        height: 350,
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      ),
      height: 50,
      child: TextField(
        controller: _searchBarController,
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
          suffixIcon: _isTextEmpty
              ? null
              : IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 20,
                    color: CustomColors.darkGrey,
                  ),
                  onPressed: () {
                    return _searchBarController.clear();
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
    );
  }

  Widget _selectedImage() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      width: 330,
      height: 270,
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
      top: 390,
      left: Get.width / 2 - 35,
      child: CustomIconButton(
        onTap: () {
          showAlertDialog(context: context, message: '아직 추천 페이지 없음');
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
    );
  }

  Widget _suggestionList() {
    return Container();
  }

  Widget _listAddButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        fixedSize: Size(260, 60),
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
                typeSelectTabBar(
                  _tabSuggestionController,
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.5),
                ),
                _selectedImage(),
                _suggestionList(),
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
