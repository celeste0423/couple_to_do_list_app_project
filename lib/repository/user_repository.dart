import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/features/auth/auth_source/firebase_auth_remote_data_source.dart';
import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/helper/show_alert_dialog.dart';
import 'package:couple_to_do_list_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class UserRepository {
  static Future<UserCredential> signInWithApple() async {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }

  static Future<UserCredential> signInWithGoogle() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    // final GoogleSignIn googleSignIn = GoogleSignIn(
    //     scopes: ['email', "https://www.googleapis.com/auth/userinfo.profile"]);
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

    // //사용자 정보 가져오기
    // final userInfo = await googleSignIn.currentUser;
    // AuthController.nickName = userInfo!.displayName;
    // Future<String> getGender() async {
    //   final headers = await googleSignIn.currentUser!.authHeaders;
    //   final r = await http.get(
    //       "https://people.googleapis.com/v1/people/me?personFields=genders&key=",
    //       headers: {"Authorization": headers["Authorization"]});
    //   final response = JSON.jsonDecode(r.body);
    //   return response["genders"][0]["formattedValue"];
    // }
    // AuthController.gender = await getGender();

    return await auth.signInWithCredential(credential);
  }

  static Future<String> signInWithKakao() async {
    final firebaseAuthDataSource = FirebaseAuthRemoteDataSource();
    bool isLogined = false;
    kakao.User? user;
    try {
      bool isInstalled = await kakao.isKakaoTalkInstalled();
      if (isInstalled) {
        try {
          await kakao.UserApi.instance.loginWithKakaoTalk();
          isLogined = true;
        } catch (e) {
          openAlertDialog(title: e.toString());
        }
      } else {
        try {
          await kakao.UserApi.instance.loginWithKakaoAccount();
          isLogined = true;
        } catch (e) {
          openAlertDialog(title: e.toString());
        }
      }
      //로그인 완료 됐으면
      if (isLogined) {
        //커스텀 토큰 생성
        user = await kakao.UserApi.instance.me();
        final customToken = await firebaseAuthDataSource.createCustomToken({
          'uid': user!.id.toString(),
          'email': user!.kakaoAccount!.email!,
        });
        return customToken;
      } else {
        return '';
      }
    } catch (e) {
      //로그인 실패
      openAlertDialog(title: e.toString());
      return '';
    }
  }

  static Future signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      if (AuthController.to.user.value.loginType == 'google') {
        //이전 로그인 기록 지우기
        try {
          await googleSignIn.signOut();
        } catch (e) {
          openAlertDialog(title: e.toString());
        }
      }
      if (AuthController.to.user.value.loginType == 'kakao') {
        //이전 로그인 기록 지우기
        try {
          await kakao.UserApi.instance.unlink();
        } catch (e) {
          openAlertDialog(title: e.toString());
        }
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

  static Future<String> getLoginType() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: AuthController.to.user.value.uid)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      String loginType = documentSnapshot.get('loginType');
      return loginType;
    } else {
      // 문서를 찾지 못한 경우 또는 필드 값이 없는 경우에 대한 처리
      return '';
    }
  }
}
