import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/helper/show_alert_dialog.dart';
import 'package:couple_to_do_list_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserRepository {
  static Future<UserCredential> signInWithGoogle() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    //구글 로그인 페이지 표시
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      return openAlertDialog(title: '로그인에 실패했습니다');
    }
    //로그인 성공, 유저정보 가져오기
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    //파이어베이스 인증 정보 로그인
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // print(googleAuth.accessToken);
    // print(googleAuth.idToken);
    print('구글에 로그인(user repo)');
    return await auth.signInWithCredential(credential);
  }

  static Future signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      if (AuthController.to.user.value.loginType == 'google') {
        //이전 로그인 기록 지우기
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('로그아웃 실패${e.toString()}');
    }
  }

  static Future<UserModel?> loginUserByEmail(String email) async {
    try {
      var data = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (data.size == 0) {
        //아직 회원가입이 안되었기 때문에 파이어스토어에 추가해야함
        return null;
      } else {
        // print('가입 이력 존재(repo)${data.docs.first.data().toString()}');
        return UserModel.fromJson(data.docs.first.data());
      }
    } catch (e) {
      //예외처리를 잘하자..ㅎ
      print('loginUserByUid 에러(user repo): $e');
      return null;
    }
  }
  // static Future<UserModel?> loginUserByUid(String uid) async {
  //   try {
  //     // print('uid이거임(repo) $uid');
  //     var data = await FirebaseFirestore.instance
  //         .collection('users')
  //         .where('uid', isEqualTo: uid)
  //         .get();
  //     // print('파이어베이스 탐색완료(repo)');
  //
  //     if (data.size == 0) {
  //       //아직 회원가입이 안되었기 때문에 파이어스토어에 추가해야함
  //       // print('uid 일치 데이터 없음(repo)');
  //       return null;
  //     } else {
  //       // print('가입 이력 존재(repo)${data.docs.first.data().toString()}');
  //       return UserModel.fromJson(data.docs.first.data());
  //     }
  //   } catch (e) {
  //     //예외처리를 잘하자..ㅎ
  //     print('loginUserByUid 에러: $e');
  //     return null;
  //   }
  // }

  static Future<bool> firestoreSignup(UserModel user) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(user.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> googleAccountDeletion() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.currentUser?.delete();
  }

  static Future<void> updateGroupId(UserModel user, String groupId) async {
    FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user.email)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(doc.id)
            .update({'groupId': groupId});
      });
    });
  }

  static Future<bool> findGroupId(String email) async {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get()
          .then((querySnapshot) {
        var groupId = querySnapshot.docs[0].data()['groupId'];
        if (groupId == null) {
          return false;
        } else {
          return true;
        }
      });
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
