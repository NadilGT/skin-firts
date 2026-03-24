// ignore_for_file: unused_local_variable

import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_firts/core/storage/data_state.dart';
import 'package:skin_firts/data/models/find_role_model/find_role_model.dart';
import 'package:skin_firts/data/models/login_user_model/login_user_model.dart';
import 'package:skin_firts/data/models/register_user_model/register_user_model.dart';
import 'package:skin_firts/data/models/sign_up_user_model/sign_up_user_model.dart';
import 'package:skin_firts/domain/repositories/auth/auth_firebase_service.dart';
import 'package:skin_firts/domain/repositories/find_role_repository/find_role_repository.dart';
import 'package:skin_firts/domain/repositories/register_user_repository/register_user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skin_firts/service_locator.dart';

class AuthFirebaseServiceImpl implements AuthFirebaseService {
  @override
  Future<DataState<LoginUserModel>> signIn(LoginUserModel loginUserModel) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: loginUserModel.email,
        password: loginUserModel.password,
      );

      final firebaseUid = userCredential.user!.uid;

      // Check role — only 'patient' is allowed access
      final roleResult = await sl<FindRoleRepository>().findRole(firebaseUid);

      if (roleResult is DataFailed) {
        await FirebaseAuth.instance.signOut();
        return DataFailed(roleResult.error ?? 'Could not verify your role. Please try again.');
      }

      final role = (roleResult as DataSuccess<FindRoleResponseModel>).data!.role;
      if (role != 'patient') {
        await FirebaseAuth.instance.signOut();
        return DataFailed('Access denied. This app is only for patients.');
      }

      final prefs = await SharedPreferences.getInstance();
      prefs.setString("email", loginUserModel.email);
      return DataSuccess(loginUserModel);

    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'invalid-email') {
        message = 'No user found for that email.';
      } else if (e.code == 'invalid-credential') {
        message = 'Wrong password provided for that user.';
      }
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
