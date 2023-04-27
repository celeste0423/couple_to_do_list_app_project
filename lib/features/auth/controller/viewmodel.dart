import 'package:couple_to_do_list_app/features/auth/controller/login.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class MainViewModel{
  final KakaoLogin _socialLogin;
  MainViewModel(this._socialLogin);

  bool isLogined = false;
  User? user; //user import

  Future login()async{
    isLogined = await _socialLogin.login();
    if(isLogined){
      user = await UserApi.instance.me();// 현재 접속한 유저정보를 가져옴
    }
  }

  Future logout() async{
    await _socialLogin.logout();
    isLogined = false;
    user = null;
}
}