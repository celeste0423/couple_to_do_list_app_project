import 'package:couple_to_do_list_app/features/auth/pages/find_buddy_page.dart';
import 'package:couple_to_do_list_app/features/auth/widgets/registration_stage.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserRegistrationPage extends StatefulWidget {
  const UserRegistrationPage({Key? key}) : super(key: key);

  @override
  State<UserRegistrationPage> createState() => _UserRegistrationPageState();
}

class _UserRegistrationPageState extends State<UserRegistrationPage> {
  final List<bool> isSelected = <bool>[false, false];
  TextEditingController nickname = TextEditingController();
  TextEditingController birthday = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColors.mainPink,
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  '신규 등록',
                  style: TextStyle(
                    color: CustomColors.darkGrey,
                    fontSize: 50,
                  ),
                ),
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
                                children: const [
                                  Text(
                                    '닉네임',
                                    style: TextStyle(
                                      color: CustomColors.darkGrey,
                                      fontSize: 35,
                                    ),
                                  ),
                                  Text(
                                    '성별',
                                    style: TextStyle(
                                      color: CustomColors.darkGrey,
                                      fontSize: 35,
                                    ),
                                  ),
                                  Text(
                                    '생일',
                                    style: TextStyle(
                                      color: CustomColors.darkGrey,
                                      fontSize: 35,
                                    ),
                                  ),
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
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    height: 50,
                                    child: TextField(
                                      controller: nickname,
                                      decoration: InputDecoration(
                                        labelText: 'ex) 돼지길동',
                                        prefixIcon: Icon(Icons.account_circle),
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.close, size: 20),
                                          onPressed: () {
                                            return nickname.clear();
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0))),
                                    height: 50,
                                    child: ToggleButtons(
                                      onPressed: (int index) {
                                        setState(
                                          () {
                                            for (int i = 0;
                                                i < isSelected.length;
                                                i++) {
                                              isSelected[i] = i == index;
                                            }
                                          },
                                        );
                                      },
                                      disabledColor: Colors.black,
                                      selectedColor: CustomColors.lightPink,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                      // selectedBorderColor: CustomColors.lightPink,
                                      fillColor: CustomColors.lightPink,
                                      constraints:
                                          const BoxConstraints(minWidth: 80),
                                      isSelected: isSelected,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Image.asset(
                                              'assets/images/boy.png'),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Image.asset(
                                              'assets/images/girl.png'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    height: 50,
                                    child: TextField(
                                      controller: birthday,
                                      decoration: InputDecoration(
                                          labelText: 'ex) 960102',
                                          prefixIcon:
                                              Icon(Icons.account_circle),
                                          suffixIcon: IconButton(
                                              icon: Icon(Icons.close, size: 20),
                                              onPressed: () {
                                                return birthday.clear();
                                              })),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            backgroundColor:
                                CustomColors.lightPink, // Background color
                          ),
                          onPressed: () {
                            Get.to(FindBuddyPage());
                          },
                          child: Text(
                            '등록하기',
                            style: TextStyle(fontSize: 35, color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
