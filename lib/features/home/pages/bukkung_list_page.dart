import 'package:couple_to_do_list_app/helper/show_alert_dialog.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/material.dart';

class BukkungListPage extends StatelessWidget {
  const BukkungListPage({Key? key}) : super(key: key);

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
      body: Center(
        child: Text('버꿍리스트 페이지'),
      ),
    );
  }
}
