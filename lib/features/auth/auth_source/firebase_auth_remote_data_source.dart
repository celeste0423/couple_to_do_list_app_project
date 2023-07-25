import 'package:http/http.dart' as http;

class FirebaseAuthRemoteDataSource {
  Future<String> createCustomToken(Map<String, dynamic> user) async {
    final String url =
        'https://us-central1-bukkunglist.cloudfunctions.net/createCustomToken';

    //user정보를 http로 전부 보내서 토큰을 받아옴
    final customTokenResponse = await http.post(Uri.parse(url), body: user);
    print(customTokenResponse.body);
    return customTokenResponse.body;
  }
}
