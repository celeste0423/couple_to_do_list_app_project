import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.mainPink,
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              child: const Text(
                '내 짝꿍과 \n 이루고 싶은 버킷리스트',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
            ),
          ),
          const Expanded(
            flex: 1,
            child: Text(
              '버꿍리스트',
              style: TextStyle(
                color: Colors.black,
                fontSize: 65,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Image.asset('assets/images/ggomool.png'),
          ),
          Expanded(
            flex: 3,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(45),
                  topLeft: Radius.circular(45),
                ),
              ),
              child: Container(),
            ),
          ),
        ],
      ),
    );
  }

  Widget KakaoTalkButton() {
    return Container(
      width: 100,
      height: 50,
      child: TextButton(
        onPressed: () {},
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered)) {
                return Colors.yellow;
              }
              return Colors.yellow;
            },
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.chat_bubble,
              color: CustomColors.black,
            ),
            Text(
              'Login',
              style: TextStyle(
                fontFamily: '',
                color: CustomColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
