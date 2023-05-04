import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/features/auth/model/user_model.dart';
import 'package:couple_to_do_list_app/features/auth/pages/find_buddy_page.dart';
import 'package:couple_to_do_list_app/features/auth/widgets/registration_stage.dart';
import 'package:couple_to_do_list_app/helper/show_alert_dialog.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:couple_to_do_list_app/widgets/main_button.dart';
import 'package:couple_to_do_list_app/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({
    Key? key,
    required this.uid,
    required this.email,
  }) : super(key: key);
  final String uid;
  final String email;

  @override
  State<SignupPage> createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  final List<bool> isSelected = <bool>[false, false];
  String? gender = null;

  final AuthController authController = AuthController();

  TextEditingController nicknameController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();

  Widget _topBackground() {
    return Column(
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
    );
  }

  Widget _registerTap() {
    return Container(
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
              child: _inputField(),
            ),
            _registerButton(),
            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _inputField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              registerTextField(
                'ex) 홍길동',
                nicknameController,
                () {
                  return nicknameController.clear();
                },
                TextInputType.text,
              ),
              genderSelector(),
              registerTextField(
                'ex) 20010102',
                birthdayController,
                () {
                  return birthdayController.clear();
                },
                TextInputType.number,
              ),
            ],
          ),
        ),
      ],
    );
  }

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
              if (index == 0) {
                gender = 'male';
              } else {
                gender = 'female';
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
    Function()? onPressed,
    TextInputType? numberinput,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      height: 50,
      child: TextFormField(
        keyboardType: numberinput,
        controller: controller,
        decoration: InputDecoration(
          hintText: text,
          hintStyle: TextStyle(
            fontSize: 20,
          ),
          suffixIcon: IconButton(
              icon: Icon(Icons.close, size: 20), onPressed: onPressed),
        ),
      ),
    );
  }

  Widget _registerButton() {
    bool birthValidation() {
      int birthYear = int.parse(birthdayController.text.substring(0, 4));
      int birthMonth = int.parse(birthdayController.text.substring(4, 6));
      int birthDay = int.parse(birthdayController.text.substring(6));

      if (birthdayController.text.length == 8 &&
          birthYear >= 1900 &&
          birthMonth >= 1 &&
          birthMonth <= 12 &&
          birthDay >= 1 &&
          birthDay <= 32) {
        return true;
      } else {
        return false;
      }
    }

    return mainButton('등록하기', () async {
      if (nicknameController == null) {
        showAlertDialog(context: context, message: '닉네임을 올바르게 작성해주세요');
      }
      if (!birthValidation()) {
        showAlertDialog(context: context, message: '생일을 올바르게 작성해주세요');
      }
      if (gender == null) {
        showAlertDialog(context: context, message: '성별을 기입해주세요');
      }
      if (nicknameController != null && birthValidation() && gender != null) {
        DateTime birthdayDateTime = DateTime.parse(
            '${birthdayController.text.substring(0, 4)}-${birthdayController.text.substring(4, 6)}-${birthdayController.text.substring(6, 8)}');

        var signupUser = UserModel(
          uid: widget.uid,
          email: widget.email,
          nickname: nicknameController.text,
          gender: gender,
          birthday: birthdayDateTime,
        );
        await AuthController.to.signup(signupUser);
        Get.to(() => FindBuddyPage(
              email: widget.email,
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: CustomColors.mainPink,
        body: SafeArea(
          child: Stack(
            children: [
              _topBackground(),
              Positioned(
                bottom: 0,
                child: _registerTap(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
