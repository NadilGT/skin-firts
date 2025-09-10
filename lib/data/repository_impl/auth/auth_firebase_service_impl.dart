import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_firts/core/storage/data_state.dart';
import 'package:skin_firts/data/models/login_user_model/login_user_model.dart';
import 'package:skin_firts/domain/repositories/auth/auth_firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/storage/shared_pref_manager.dart';

class AuthFirebaseServiceImpl implements AuthFirebaseService {
  @override
  Future<DataState<LoginUserModel>> signIn(LoginUserModel loginUserModel) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: loginUserModel.email,
        password: loginUserModel.password,
      );
      print("wade goda");
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("email",loginUserModel.email);
      return DataSuccess(loginUserModel);

    } on FirebaseAuthException catch (e) {
      String message = '';

      if(e.code == 'invalid-email'){
        message = 'Not user found for that email';
      } else if(e.code == 'invalid-credential'){
        message = 'Wrong password provided for that user';
      }
      // ignore: avoid_print
      print(message);

      return DataFailed(message);
    }
  }
}
