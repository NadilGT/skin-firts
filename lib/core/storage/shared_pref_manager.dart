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

  static const String _branchIdKey = 'branch_id';

  Future<void> saveBranchId(String branchId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_branchIdKey, branchId);
  }

  Future<String?> getBranchId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_branchIdKey);
  }
}