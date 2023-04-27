import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/features/auth/widgets/registration_stage.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:couple_to_do_list_app/widgets/main_button.dart';
import 'package:couple_to_do_list_app/widgets/title_text.dart';
import 'package:flutter/material.dart';

class UserRegistrationPage extends StatefulWidget {
  const UserRegistrationPage({Key? key}) : super(key: key);

  @override
  State<UserRegistrationPage> createState() => UserRegistrationPageState();
}

class UserRegistrationPageState extends State<UserRegistrationPage> {
  final List<bool> isSelected = <bool>[false, false];

  final AuthController authController = AuthController();

  TextEditingController nicknameController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();

  Widget registerText(String text) {
    return Text(
      text,
      style: TextStyle(
        color: CustomColors.darkGrey,
        fontSize: 35,
      ),
    );
  }

  Widget genderSelector() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      height: 50,
      child: ToggleButtons(
        onPressed: (int index) {
          setState(
            () {
              for (int i = 0; i < isSelected.length; i++) {
                isSelected[i] = i == index;
              }
            },
          );
        },
        disabledColor: Colors.black,
        selectedColor: CustomColors.lightPink,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        // selectedBorderColor: CustomColors.lightPink,
        fillColor: CustomColors.lightPink,
        constraints: const BoxConstraints(minWidth: 80),
        isSelected: isSelected,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Image.asset('assets/images/boy.png'),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Image.asset('assets/images/girl.png'),
          ),
        ],
      ),
    );
  }

  Widget registerTextField(
    String text,
    TextEditingController controller,
    Function onPressed,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      height: 50,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: text,
          hintStyle: TextStyle(
            fontSize: 20,
          ),
          prefixIcon: Icon(Icons.account_circle),
          suffixIcon: IconButton(
            icon: Icon(Icons.close, size: 20),
            onPressed: () {
              onPressed;
            },
          ),
        ),
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
        backgroundColor: CustomColors.mainPink,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  titleText('신규 등록'),
                  SizedBox(
                    height: 15,
                  ),
                  RegistrationStage(1),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Image.asset('assets/images/handshake.png'),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(45),
                      topLeft: Radius.circular(45),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 9 / 16,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    registerText('닉네임'),
                                    registerText('성별'),
                                    registerText('생일'),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    registerTextField(
                                      'ex) 돼지길동',
                                      nicknameController,
                                      () {
                                        return nicknameController.clear();
                                      },
                                    ),
                                    genderSelector(),
                                    registerTextField(
                                      'ex) 960102',
                                      birthdayController,
                                      () {
                                        return birthdayController.clear();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        mainButton('등록하기', () {
                          authController
                              .changeRegisterProgressIndex('findBuddy');
                        }),
                        SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
