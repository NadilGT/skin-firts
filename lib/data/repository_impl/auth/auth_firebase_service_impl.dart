// ignore_for_file: unused_local_variable

import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_firts/core/storage/data_state.dart';
import 'package:skin_firts/data/models/login_user_model/login_user_model.dart';
import 'package:skin_firts/data/models/register_user_model/register_user_model.dart';
import 'package:skin_firts/data/models/sign_up_user_model/sign_up_user_model.dart';
import 'package:skin_firts/domain/repositories/auth/auth_firebase_service.dart';
import 'package:skin_firts/domain/repositories/register_user_repository/register_user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skin_firts/service_locator.dart';

class AuthFirebaseServiceImpl implements AuthFirebaseService {
  @override
  Future<DataState<LoginUserModel>> signIn(LoginUserModel loginUserModel) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: loginUserModel.email,
        password: loginUserModel.password,
      );
      final token = await FirebaseAuth.instance.currentUser?.getIdToken(true);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("email", loginUserModel.email);
      return DataSuccess(loginUserModel);

    } on FirebaseAuthException catch (e) {
      String message = '';

      if (e.code == 'invalid-email') {
        message = 'Not user found for that email';
      } else if (e.code == 'invalid-credential') {
        message = 'Wrong password provided for that user';
      }
      // ignore: avoid_print
      print(message);

      return DataFailed(message);
    }
  }

  @override
  Future<DataState<SignUpUserModel>> signUp(SignUpUserModel signUpUserModel) async {
    try {
      // Step 1: Create Firebase account
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: signUpUserModel.email,
        password: signUpUserModel.password,
      );
      await userCredential.user?.updateDisplayName(signUpUserModel.name);

      final firebaseUid = userCredential.user!.uid;

      // Step 2: Register the patient in the backend using the firebaseUid
      final registerResult = await sl<RegisterUserRepository>().registerPatient(
        RegisterUserModel(
          firebaseUid: firebaseUid,
          name: signUpUserModel.name,
          email: signUpUserModel.email,
          phoneNumber: signUpUserModel.phoneNumber,
        ),
      );

      if (registerResult is DataFailed) {
        // Firebase account created but backend registration failed
        // Delete the Firebase account to keep them in sync
        await userCredential.user?.delete();
        return DataFailed(
          'Account creation failed: ${registerResult.error ?? "Could not register user"}',
        );
      }

      return DataSuccess(signUpUserModel);
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      }
      return DataFailed(message);
    }
  }
}
