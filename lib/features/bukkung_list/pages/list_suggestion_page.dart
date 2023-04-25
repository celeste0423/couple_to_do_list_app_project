import 'package:couple_to_do_list_app/helper/show_alert_dialog.dart';
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
    return Container();
  }

  Widget _suggestionList() {
    return Container();
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
            '추천 버꿍리스트',
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
            )
          ],
        ),
      ),
    );
  }
}
