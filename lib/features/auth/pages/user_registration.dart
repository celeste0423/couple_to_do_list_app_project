import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

Widget RegistrationStage(int n) {
  return Container(
    height: 40,
    child: Stack(children: [
      Align(
          alignment: Alignment.center,
          child: LinearProgressIndicator(
            color: CustomColors.lightPink,
            backgroundColor: Colors.white,
          )),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Center(
                child: Text(
              '1',
              style: TextStyle(color: CustomColors.grey, fontSize: 35),
            )),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(
            width: 45,
          ),
          Container(
            child: Center(
                child: Text(
              '2',
              style: TextStyle(
                  color: n >= 2 ? CustomColors.grey : Colors.white,
                  fontSize: 35),
            )),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              color: n >= 2 ? Colors.white : CustomColors.mainPink,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(
            width: 45,
          ),
          Container(
            child: Center(
                child: Text(
              '3',
              style: TextStyle(
                  color: n >= 3 ? CustomColors.grey : Colors.white,
                  fontSize: 35),
            )),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              color: n >= 3 ? Colors.white : CustomColors.mainPink,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    ]),
  );
}

class User_registrationPage extends StatefulWidget {
  User_registrationPage({Key? key}) : super(key: key);

  @override
  State<User_registrationPage> createState() => _User_registrationPageState();
}

class _User_registrationPageState extends State<User_registrationPage> {
  final List<bool> isSelected = <bool>[false, false];
  TextEditingController nickname = TextEditingController();
  TextEditingController birthday = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColors.mainPink,
        body: Stack(children: [
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
                  child: Image.asset('assets/images/handshake.png'))
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
                                  ]),
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
                                            Radius.circular(20))),
                                    height: 50,
                                    child: TextField(
                                      controller: nickname,
                                      decoration: InputDecoration(
                                          labelText: 'ex) 돼지길동',
                                          prefixIcon:
                                              Icon(Icons.account_circle),
                                          suffixIcon: IconButton(
                                              icon: Icon(Icons.close, size: 20),
                                              onPressed: () {
                                                return nickname.clear();
                                              })),
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
                                        setState(() {
                                          for (int i = 0;
                                              i < isSelected.length;
                                              i++) {
                                            isSelected[i] = i == index;
                                          }
                                        });
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
                                        )
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
                          ]),
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
                          )),
                    ),
                    SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}

class FindBuddyPage extends StatefulWidget {
  FindBuddyPage({Key? key}) : super(key: key);

  @override
  State<FindBuddyPage> createState() => _FindBuddyPageState();
}

class _FindBuddyPageState extends State<FindBuddyPage> {
  TextEditingController email = TextEditingController();

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
                '짝꿍 찾기',
                style: TextStyle(
                  color: CustomColors.darkGrey,
                  fontSize: 50,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              RegistrationStage(2),
              SizedBox(
                height: 15,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: Image.asset('assets/images/handshake.png')),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: CustomColors.redbrown,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(45),
                      topLeft: Radius.circular(45),
                    ),
                  ),
                  child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(onPressed: (){Get.to(WaitBuddyPage());}, child: Text('임시 버튼', style: TextStyle(color: Colors.red),)),
                      Text('내 이메일', style: TextStyle(fontSize: 30, color: Colors.white),),
                      TextButton(onPressed: (){Clipboard.setData(ClipboardData(
                          text: 'ddosy99@naver.com'))
                          .then((_) {Get.snackbar('이메일', '복사 완료', icon:Icon(Icons.email), snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
                      });}, child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('ddosy99@naver.com', style: TextStyle(fontSize: 30, color: Colors.white),),
                          SizedBox(width: 10,),
                          Icon(Icons.copy, size: 30,),
                          SizedBox(width: 10,),
                        ],
                      )),
                      SizedBox(height: 50,)
                    ],
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.all(20),
              height: 250,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(30.0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset(
                    'assets/images/email.png',
                    color: CustomColors.grey,
                    height: 70,
                  ),
                  Text(
                    '짝꿍의 이메일을 입력하세요',
                    style: TextStyle(fontSize: 30, color: CustomColors.grey),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    height: 40,
                    child: TextField(
                      controller: email,
                      decoration: InputDecoration(
                          labelText: 'ddosy99@naver.com',
                          prefixIcon: Icon(Icons.email),
                          suffixIcon: IconButton(
                              icon: Icon(Icons.clear, size: 20),
                              onPressed: () {
                                return email.clear();
                              })),
                    ),
                  ),
                  SizedBox(height: 40,)
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}

class WaitBuddyPage extends StatelessWidget {
  const WaitBuddyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: CustomColors.mainPink,
      body: Stack(
        children: [Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              '짝꿍을 기다리는 중...',
              style: TextStyle(
                color: CustomColors.darkGrey,
                fontSize: 50,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            RegistrationStage(3),
            SizedBox(
              height: 15,
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Image.asset('assets/images/handshake.png')),
          ],
        ),
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(20),
              height: 150,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(30.0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '짝꿍에게 내 이메일을 알려줘요!',
                    style: TextStyle(fontSize: 30, color: CustomColors.grey),
                  ),
                  TextButton(onPressed: (){
                    Clipboard.setData(ClipboardData(
                        text: 'ddosy99@naver.com'))
                        .then((_) {Get.snackbar('이메일 복사 완료', '복사 완료', icon:Icon(Icons.email), snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
                    });
                  }, child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('ddosy99@naver.com', style: TextStyle(fontSize: 30, color: Colors.red),),
                      SizedBox(width: 10,),
                      Icon(Icons.copy, size: 30, color: CustomColors.grey,),
                      SizedBox(width: 10,),
                    ],
                  )),
                  SizedBox(height: 20,),
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}
