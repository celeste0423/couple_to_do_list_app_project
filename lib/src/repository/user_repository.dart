import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/src/features/auth/auth_source/firebase_auth_remote_data_source.dart';
import 'package:couple_to_do_list_app/src/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/src/helper/open_alert_dialog.dart';
import 'package:couple_to_do_list_app/src/models/group_model.dart';
import 'package:couple_to_do_list_app/src/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:google_sign_in/google_sign_in.dart' as google;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:sign_in_with_apple/sign_in_with_apple.dart' as apple;
import 'package:uuid/uuid.dart';

class UserRepository {
  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // 로그인 성공 시 처리
      } else {
        // 로그인 실패 시 처리
        //print('Login failed');
      }
    } catch (e) {
      print(e.toString());
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          // 등록된 사용자 없음 -> 회원가입으로 처리
          try {
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: email,
              password: password,
            );
            // 회원가입 성공 시 처리
          } catch (e) {
            // 회원가입 실패 시 처리
            //print('Error during sign up: $e');
          }
        } else {
          // 다른 에러 처리
          //print('Error: $e');
        }
      }
    }
  }

  static Future<UserCredential> appleFlutterWebAuth() async {
    final clientState = Uuid().v4();
    final url = Uri.https('appleid.apple.com', '/auth/authorize', {
      'response_type': 'code id_token',
      'client_id': "com.example.coupleToDoListApp.web",
      'response_mode': 'form_post',
      'redirect_uri':
          'https://bottlenose-tungsten-rumba.glitch.me/callbacks/apple/sign_in',
      'scope': 'email name',
      'state': clientState,
    });

    final result = await FlutterWebAuth.authenticate(
        url: url.toString(), callbackUrlScheme: "applink");

    final body = Uri.parse(result).queryParameters;
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: body['id_token'],
      accessToken: body['code'],
    );
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }

  static Future<UserCredential> iosSignInWithApple() async {
    final appleCredential = await apple.SignInWithApple.getAppleIDCredential(
      scopes: [
        apple.AppleIDAuthorizationScopes.email,
        apple.AppleIDAuthorizationScopes.fullName,
      ],
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );
    //print(oauthCredential);
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }

  static Future<UserCredential> androidSignInWithApple() async {
    final appleCredential = await apple.SignInWithApple.getAppleIDCredential(
      scopes: [
        apple.AppleIDAuthorizationScopes.email,
        apple.AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: apple.WebAuthenticationOptions(
        clientId: "com.example.coupleToDoListApp.web",
        redirectUri: Uri.parse(
            "https://bottlenose-tungsten-rumba.glitch.me/callbacks/sign_in_with_apple"),
      ),
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );
    //print(oauthCredential);
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }

  static Future<UserCredential> signInWithGoogle() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final google.GoogleSignIn googleSignIn = google.GoogleSignIn(
      scopes: [
        'email',
      ],
    );
    // final GoogleSignIn googleSignIn = GoogleSignIn(
    //     scopes: ['email', "https://www.googleapis.com/auth/userinfo.profile"]);
    //구글 로그인 페이지 표시
    final google.GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      return openAlertDialog(title: '로그인 정보가 없습니다.');
    }
    //로그인 성공, 유저정보 가져오기
    final google.GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    //print('(user repo) idtoken ${googleAuth.idToken}');
    //print('(user repo) accesstoken ${googleAuth.accessToken}');
    //파이어베이스 인증 정보 로그인
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    print('(user repo) credential $credential');
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
          print('카카오 로그인 시도');
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
        print('커스텀 토큰 생성 시작');
        user = await kakao.UserApi.instance.me();
        print(user.kakaoAccount.toString());
        final customToken = await firebaseAuthDataSource.createCustomToken({
          'uid': user.id.toString(),
          'email': user.kakaoAccount!.email!,
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
    final google.GoogleSignIn googleSignIn = google.GoogleSignIn();
    try {
      if (AuthController.to.user.value.loginType == 'google') {
        //이전 로그인 기록 지우기
        //todo: 해보니까 이전 로그인 기록 지워지지 않은것 같은데 그럼 왜 await googleSignIn.signOut();가 필요한거지?일단 앱 돌아가는데 아무 문제 없으니 스킵.
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
      if (AuthController.to.user.value.loginType == 'apple') {
        try {
          //apple 은 굳이 unlink 할 필요 없을듯?
        } catch (e) {
          openAlertDialog(title: e.toString());
        }
      }
      await FirebaseAuth.instance.signOut();
      print('await FirebaseAuth.instance.signOut();');
      AuthController.to.clearAuthController();
      print(
          "로그아웃 성공! AuthController.to.user.value.email = ${AuthController.to.user.value.email}");
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

  static Future getUserData(String uid) async {
    var data = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .get();

    if (data.size == 0) {
      // print('uid 일치 데이터 없음(repo)');
      return null;
    } else {
      // print('가입 이력 존재(repo)${data.docs.first.data().toString()}');
      return UserModel.fromJson(data.docs.first.data());
    }
  }

  static Stream<UserModel?> getUserStream(String uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return null;
      } else {
        return UserModel.fromJson(snapshot.docs.first.data());
      }
    });
  }

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
    final auth = FirebaseAuth.instance;
    // credential = GoogleAuthProvider.credential();
    //await FirebaseAuth.instance.currentUser?.reauthenticateWithCredential(credential);
    await auth.currentUser?.delete();
    print('_auth.currentUser!.delete(); 완료');
    await auth.signOut();
    print('_auth.signOut(); 완료');
    await google.GoogleSignIn().signOut();
    print('google signout 완료');
  }

  static Future<void> updateGroupId(UserModel user, String groupId) async {
    FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user.email)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        FirebaseFirestore.instance.collection('users').doc(doc.id).update(
          {'groupId': groupId},
        );
      }
    });
  }

  static Future<void> updateNickname(String nickname) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(AuthController.to.user.value.uid)
          .update({'nickname': nickname});
    } catch (e) {
      openAlertDialog(title: '닉네임 업데이트 중 오류가 발생했습니다.', content: e.toString());
    }
  }

  static Future<GroupModel?> getGroupModel(String email) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        //나에게 group이 있다면
        String? groupId = querySnapshot.docs[0].data()['groupId'];
        print('검색한 그룹Id (user repo) $groupId');
        if (groupId == null) {
          print('그룹 아이디 없음(user repo)');
          return null;
        } else {
          print(
              'AuthController.to.user.value.nickname ${AuthController.to.user.value.nickname}');
          AuthController.to
              .user(AuthController.to.user.value.copyWith(groupId: groupId));
          print(
              'AuthController.to.user.value.groupId ${AuthController.to.user.value.groupId}');
          var snapshot = await FirebaseFirestore.instance
              .collection('groups')
              .doc(groupId)
              .get();
          print('그룹 아이디 있음(user repo)');
          if (!snapshot.exists) {
            print('에러 그룹 없음(gro repo)');
            return null;
          }
          return GroupModel.fromJson(snapshot.data()!);
        }
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
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

  static Future<UserModel?> getUserDataByUid(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    print('유저 정보 가져오는 중');
    if (snapshot.exists) {
      UserModel userdata = UserModel.fromJson(snapshot.data()!);
      return userdata;
    } else {
      print('(user repo) 유저정보 가져오기 실패');
      return null;
    }
  }
}
