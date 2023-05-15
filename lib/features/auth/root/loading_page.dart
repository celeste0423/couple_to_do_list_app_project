import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/features/auth/root/root.dart';
import 'package:couple_to_do_list_app/features/auth/root/testpage.dart';
import 'package:couple_to_do_list_app/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  final AuthController authController = AuthController();


  Future<UserModel?> getuserData() async {
    String? uid = authController.user.value.uid;


    if (uid==null){
      return null;
    }
    else{
      final data = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get();
      return UserModel.fromJson(data.data()!);
    }
  }

  @override
  void initState() {
    super.initState();
    Future<UserModel?> data = getuserData();
    print('loading page: got the user data');
    print(data);
    //이 페이지 빌드가 끝나고 바로 다음페이지로 이동할 수 있게
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Get.to(Root(data));
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return
      ElevatedButton(onPressed: (){
      }, child: Text('testpage 이동'));
    ;
  }
}
