import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/features/auth/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserRepository {
  static Future<UserModel?> loginUserByUid(String uid) async {
    print('uid이거임 $uid');
    var data = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .get();

    if (data.size == 0) {
      //아직 회원가입이 안되었기 때문에 파이어스토어에 추가해야함
      print('uid 일치 데이터 없음');
      // UserRepository.googleAccountDeletion();
      // Get.to(() => WelcomePage());
      return null;
    } else {
      return UserModel.fromJson(data.docs.first.data());
    }
  }

  static Future<bool> firestoreSignup(UserModel user) async {
    try {
      await FirebaseFirestore.instance.collection('users').add(user.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> googleAccountDeletion() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.currentUser?.delete();
  }
}
