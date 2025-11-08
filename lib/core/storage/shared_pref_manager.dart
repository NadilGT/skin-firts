import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefManager {
  static const String _accessTokenKey = 'access_token';

  Future<void> saveToken(String token)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(_accessTokenKey);
    return token;
  }
}