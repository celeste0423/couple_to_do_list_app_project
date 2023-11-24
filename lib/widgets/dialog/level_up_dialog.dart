import 'dart:async';

import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LevelUpDialog extends StatefulWidget {
  int previousLevel;
  int currentLevel;

  LevelUpDialog({
    Key? key,
    required this.previousLevel,
    required this.currentLevel,
  }) : super(key: key);

  @override
  State<LevelUpDialog> createState() => _LevelUpDialogState();
}

class _LevelUpDialogState extends State<LevelUpDialog>
    with SingleTickerProviderStateMixin {
  double percentage = 0.0;
  bool isLevelChanged = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animation.addListener(() {
      setState(() {});
    });
    startTimer();
  }

  void startTimer() {
    const period = const Duration(milliseconds: 8);
    Timer.periodic(
      period,
      (Timer timer) {
        setState(() {
          if (percentage < 0.99) {
            percentage += 0.01;
          } else {
            timer.cancel();
            print('타이머 끝 ${_animation.value}');
            _animationController.forward();
          }
        });
      },
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // 애니메이션이 완료된 후에 다른 애니메이션 실행
        isLevelChanged = true;
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Get.width < 350 || Get.height < 550
          ? SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(),
              ),
            )
          : SizedBox(
              height: 550,
              width: 350,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(240),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            offset: Offset(0, 15),
                            blurRadius: 10,
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            offset: Offset(0, -15),
                            blurRadius: 10,
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            offset: Offset(15, 0),
                            blurRadius: 10,
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            offset: Offset(-15, 0),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: SizedBox(
                              height: 180,
                              width: 180,
                              child: CircularProgressIndicator(
                                strokeWidth: 8,
                                value: percentage,
                                color: CustomColors.mainPink,
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 80,
                                left: 120 * _animation.value,
                              ),
                              child: SizedBox(
                                height: 180,
                                child: isLevelChanged
                                    ? Text(
                                        'LV.${widget.currentLevel}',
                                        style: TextStyle(
                                          color: CustomColors.blackText
                                              .withOpacity(
                                                  1 - _animation.value),
                                          fontWeight: FontWeight.w800,
                                          fontSize: 30,
                                        ),
                                      )
                                    : Text(
                                        'LV.${widget.previousLevel}',
                                        style: TextStyle(
                                          color: CustomColors.blackText
                                              .withOpacity(
                                                  1 - _animation.value),
                                          fontWeight: FontWeight.w800,
                                          fontSize: 30,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
