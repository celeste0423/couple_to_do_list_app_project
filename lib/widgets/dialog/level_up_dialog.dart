import 'dart:async';

import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:couple_to_do_list_app/widgets/main_button.dart';
import 'package:couple_to_do_list_app/widgets/text/PcText.dart';
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
    with TickerProviderStateMixin {
  double percentage = 0.0;
  bool isLevelChanged = false;
  late AnimationController _levelAnimationController;
  late Animation<double> _levelAnimation;
  bool isTextVisible = false;
  late AnimationController _textAnimationController;
  late Animation<double> _textAnimation;

  double circularProgressOpacity = 1.0;
  double gifOpacity = 0;
  double congratulationsOpacity = 0;
  double levelUpOpacity = 0;

  @override
  void initState() {
    super.initState();
    _levelAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    // _levelAnimation =
    //     Tween<double>(begin: 0, end: 1).animate(_levelAnimationController);
    _levelAnimation = CurvedAnimation(
      parent: _levelAnimationController,
      curve: Curves.easeInOut,
    );
    _levelAnimation.addListener(() {
      setState(() {});
    });

    _textAnimationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    // _textAnimation =
    //     Tween<double>(begin: 0, end: 1).animate(_textAnimationController);
    _textAnimation = CurvedAnimation(
      parent: _textAnimationController,
      curve: Curves.easeOut,
    );
    _textAnimation.addListener(() {
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
            print('타이머 끝 ${_levelAnimation.value}');
            _levelAnimationController.forward();
          }
        });
      },
    );

    _levelAnimationController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        // 애니메이션이 완료된 후에 다른 애니메이션 실행
        isLevelChanged = true;
        _levelAnimationController.reverse();
        await Future.delayed(const Duration(milliseconds: 300), () {
          setState(() {
            isTextVisible = true;
            circularProgressOpacity = 0;
          });
        });
      }
      Future.delayed(const Duration(milliseconds: 300), () {
        _textAnimationController.forward();
      });
      Future.delayed(const Duration(milliseconds: 2300), () {
        setState(() {
          congratulationsOpacity = 1.0;
        });
      });
      Future.delayed(const Duration(milliseconds: 2700), () {
        setState(() {
          levelUpOpacity = 1.0;
        });
      });
      Future.delayed(const Duration(milliseconds: 3100), () {
        setState(() {
          gifOpacity = 1.0;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: SizedBox(
        height: 550,
        width: 350,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    AnimatedOpacity(
                      opacity: gifOpacity,
                      duration: Duration(milliseconds: 500),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: 150,
                            left: 30,
                            right: 30,
                          ),
                          child: Image(
                            image: const AssetImage(
                              'assets/gifs/congratulation.gif',
                            ),
                          ),
                        ),
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: congratulationsOpacity,
                      duration: Duration(milliseconds: 500),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 140),
                        child: Center(
                          child: PcText(
                            'Congratulations',
                            style: TextStyle(
                              color: CustomColors.blackText,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: levelUpOpacity,
                      duration: Duration(milliseconds: 500),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 240),
                          child: PcText(
                            'LEVEL UP',
                            style: TextStyle(
                              color: CustomColors.blackText,
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                            ),
                          ),
                        ),
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: circularProgressOpacity,
                      duration: const Duration(milliseconds: 500),
                      child: Center(
                        child: Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(240),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                offset: Offset(0, 0),
                                blurRadius: 20,
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
                            ],
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: isTextVisible
                              ? 100 + 290 * (_textAnimation.value)
                              : 140,
                          left: isTextVisible ? 0 : 120 * _levelAnimation.value,
                        ),
                        child: SizedBox(
                          height: 180,
                          child: isLevelChanged
                              ? Text(
                                  'LV.${widget.currentLevel}',
                                  style: TextStyle(
                                    color: CustomColors.blackText.withOpacity(
                                        isTextVisible
                                            ? 1
                                            : 1 - _levelAnimation.value),
                                    fontWeight: FontWeight.w800,
                                    fontSize: 30,
                                  ),
                                )
                              : Text(
                                  'LV.${widget.previousLevel}',
                                  style: TextStyle(
                                    color: CustomColors.blackText
                                        .withOpacity(1 - _levelAnimation.value),
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
              MainButton(
                buttonText: '닫기',
                onTap: () {
                  Get.back();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _levelAnimationController.dispose();
    _textAnimationController.dispose();
    super.dispose();
  }
}
