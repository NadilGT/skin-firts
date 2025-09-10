import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skin_firts/core/storage/shared_pref_manager.dart';

class FirebaseAuthInterceptor extends Interceptor{
  final SharedPrefManager sharedPrefManager;

  FirebaseAuthInterceptor({required this.sharedPrefManager});

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler)async{
    String? accessToken = await sharedPrefManager.getToken();

    if (accessToken == null || await isTokenExpired()) {
      accessToken = await refreshToken();
    }

    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    super.onRequest(options, handler);
  }

  Future<bool> isTokenExpired() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return true;

    IdTokenResult tokenResult = await user.getIdTokenResult();
    DateTime expiryDate = tokenResult.expirationTime ?? DateTime.now();

    return expiryDate.isBefore(DateTime.now().add(Duration(minutes: 10)));
  }

  Future<String?> refreshToken() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String? newToken = await user.getIdToken(true);
        await sharedPrefManager.saveToken(newToken!);
        return newToken;
      }
    } catch (e) {
      print("Token refresh failed: $e");
    }
    return null;
  }
}