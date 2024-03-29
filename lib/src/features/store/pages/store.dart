import 'package:carousel_slider/carousel_slider.dart';
import 'package:couple_to_do_list_app/src/utils/custom_color.dart';
import 'package:couple_to_do_list_app/src/widgets/png_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/title_text.dart';
import '../controller/store_page_controller.dart';

class StorePage extends StatefulWidget {
  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  List<String> objectList = [
    "cozy house0",
    "cozy house1",
    "cozy house2",
    "cozy house3",
    "cozy house4"
  ];
  final CarouselController carouselController = CarouselController();
  final StorePageController _controller = Get.put(StorePageController());
  int activeIndex = 0;

  myAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: CustomColors.mainPink,
        ),
      ),
      title: TitleText(
        text: '상점',
      ),
      actions: [
        Container(
          // color: Colors.green,
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.ac_unit,
                size: 25,
              ),
              Text(
                '${_controller.seedNumber.value}',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
        ),
      ],
    );
  }

  topContainer() {
    cardWidget(index) {
      return Expanded(
        child: Container(
          padding: EdgeInsets.all(10),
          width: 200, // Adjust the width as needed
          // height: 150, // Adjust the height as needed
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15), // Rounded edges
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // Shadow color
                spreadRadius: 2, // Spread radius
                blurRadius: 5, // Blur radius
                offset: Offset(0, 3), // Offset of the shadow
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20)), // Rounded top edges
                  ),
                  child: Image.asset(
                    'assets/images/bukkung_list_icon.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'COZY HOUSE$index',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '마음 깊은 곳까지 포근한 느낌이 드는 버꿍이의 베이직 하우스',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13),
                      ),
                      Text(
                        '05/12',
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      flex: 5,
      child: Container(
        //color: Colors.blue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, top: 10),
              child: Text(
                '인테리어 오브제',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CarouselSlider.builder(
                  carouselController: carouselController,
                  itemCount: 5,
                  itemBuilder: (ctx, index, realIndex) {
                    return cardWidget(index);
                  },
                  options: CarouselOptions(
                    onPageChanged: (index, reason) {
                      setState(() {
                        activeIndex = index;
                      });
                    },
                    // enlargeStrategy: CenterPageEnlargeStrategy.height,
                    aspectRatio: 14 / 9,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 6),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.4,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: objectList.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => carouselController.animateToPage(entry.key),
                  child: Container(
                    width: 12.0,
                    height: 12.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black)
                            .withOpacity(activeIndex == entry.key ? 0.9 : 0.4)),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  bottomContainer() {
    Widget cardWidget(int index) {
      return Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30), // Round edges
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Shadow color
              spreadRadius: 2, // Spread radius
              blurRadius: 5, // Blur radius
              offset: Offset(0, 3), // Offset of the shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Add your Column children here
            Image.asset(
              'assets/images/girl.png',
              width: 45,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('소파$index'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PngIcon(
                      iconName: 'shop',
                      iconSize: 20,
                    ),
                    Text(
                      '${_controller.seedNumber.value}',
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      );
    }

    return Expanded(
      flex: 4,
      child: Container(
        //color: Colors.green,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Text(
                '카테고리 별로 보기',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3, // 3 items per row
                childAspectRatio: 1, // Aspect ratio of each grid item
                padding:
                    EdgeInsets.only(right: 10, left: 10, bottom: 10, top: 0),
                children: List.generate(
                  6, // Total number of grid items (3x2 grid)
                  (index) {
                    return cardWidget(index);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bannerContainer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        height: 55, // Set a specific height for the banner container
        decoration: BoxDecoration(
          color: Color(0xFFFAA7A7),
          borderRadius: BorderRadius.circular(20), // Round edges
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Shadow color
              spreadRadius: 5, // Spread radius
              blurRadius: 7, // Blur radius
              offset: Offset(0, 3), // Offset of the shadow
            ),
          ],
        ),
        padding: EdgeInsets.all(16), // Add padding
        child: Center(
          child: Text(
            ' 해바라기씨 무료충전소',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: Column(
        children: [
          topContainer(),
          bottomContainer(),
          bannerContainer(),
        ],
      ),
    );
  }
}
