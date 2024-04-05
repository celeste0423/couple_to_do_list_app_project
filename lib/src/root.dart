import 'package:couple_to_do_list_app/src/app.dart';
import 'package:couple_to_do_list_app/src/constants/admin_email.dart';
import 'package:couple_to_do_list_app/src/features/admin_management/pages/admin_management.dart';
import 'package:couple_to_do_list_app/src/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/src/features/auth/pages/find_buddy_page.dart';
import 'package:couple_to_do_list_app/src/features/auth/pages/signup_page.dart';
import 'package:couple_to_do_list_app/src/features/auth/pages/welcome_page.dart';
import 'package:couple_to_do_list_app/src/models/user_model.dart';
import 'package:couple_to_do_list_app/src/utils/custom_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Root extends GetView<AuthController> {
  const Root({Key? key}) : super(key: key);

  Widget loadingContainer() {
    return Container(
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator(
          color: CustomColors.mainPink,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext _, AsyncSnapshot<User?> user) {
        if (user.hasData) {
          return FutureBuilder<UserModel?>(
            future: controller.loginUser(user.data!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return loadingContainer();
              } else if (snapshot.hasError) {
                return loadingContainer();
              } else {
                return Obx(() {
                  if (controller.user.value.uid != null) {
                    if (user.data!.email == AdminEmail.adminEmail) {
                      return const AdminPage();
                    } else if (controller.user.value.groupId == null) {
                      return FindBuddyPage(email: user.data!.email!);
                    } else {
                      return App();
                    }
                  } else {
                    return SignupPage(
                      uid: user.data!.uid,
                      email: user.data!.email!,
                    );
                  }
                });
              }
            },
          );
        } else {
          return WelcomePage();
        }
      },
    );
  }
}
