import 'package:couple_to_do_list_app/features/auth/model/user_model.dart';
import 'package:couple_to_do_list_app/features/auth/pages/find_buddy_page.dart';
import 'package:couple_to_do_list_app/features/auth/pages/wait_buddy_page.dart';
import 'package:couple_to_do_list_app/features/auth/pages/welcome_page.dart';
import 'package:couple_to_do_list_app/features/auth/repository/user_repository.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();
  Rx<UserModel> user = UserModel().obs;

  Future<UserModel?> loginUser(String uid) async {
    // print('loginuser함수(cont) ${await UserRepository.loginUserByUid(uid)}');
    print('loginuser함수(cont)');
    var userData = await UserRepository.loginUserByUid(uid);
    //신규 유저일 경우 userData에 null값 반환됨
    print('loginuserbyUid 불러옴(cont)');
    if (userData != null) {
      print('유저 데이터 서버에서 들어옴(cont)');
      user(userData);
      // InitBinding.additionalBinding(); //Todo: 홈탭컨트롤러 initbinding 필요
    }
    print('유저데이터(cont) ${userData.toString()}');
    return userData; //신규 유저일 경우 null반환
}

   Future signup(UserModel signupUser) async {
    //회원가입 버튼에 사용
    var result = await UserRepository.firestoreSignup(signupUser);
    if (result) {
      loginUser(signupUser.uid!);
    }
  }

  //페이지 이동 관련
  var registerProgressIndex = 'welcome'.obs;

  //정보를 다 입력한 후 짝꿍을 기다리다가 앱을 나갔을 경우 대비
  void changeRegisterProgressIndex(String step) {
    registerProgressIndex.value = step;

    switch (registerProgressIndex.value) {
      case 'welcome':
        Get.to(() => WelcomePage());
        break;
      // case 'userRegistration':
      //   Get.to(() => SignupPage(
      //         uid: user.
      //         email: user.data!.email,
      //       ));
      //   break;
      case 'findBuddy':
        Get.to(() => FindBuddyPage());
        break;
      case 'waitBuddy':
        Get.to(() => WaitBuddyPage());
        break;

      default:
        Get.to(() => WelcomePage());
    }
  }
}

//카카오 user registration

// static AuthController instance = Get.find();
// late Rx<User?> _user;
// FirebaseAuth authentication = FirebaseAuth.instance;
//
// @override
// void onReady() {
//   super.onReady();
//   _user = Rx<User?>(authentication.currentUser);
//   _user.bindStream(authentication.userChanges());
//   ever(_user, _moveToPage);
// }
//
// _moveToPage(User? user) {
//   if (user == null) {
//     Get.offAll(() => WelcomePage());
//   } else {
//     Get.offAll(() => SignupPage());
//   }
// }
//
// void register(String email, password) async {
//   try {
//     await authentication.createUserWithEmailAndPassword(
//         email: email, password: password);
//   } catch (e) {
//     Get.snackbar(
//       "Error message",
//       "User message",
//       backgroundColor: Colors.red,
//       snackPosition: SnackPosition.BOTTOM,
//       titleText: Text(
//         "Registration is failed",
//         style: TextStyle(color: Colors.white),
//       ),
//       messageText: Text(
//         e.toString(),
//         style: TextStyle(color: Colors.white),
//       ),
//     );
//   }
// }
//
// void logout() {
//   authentication.signOut();
