import 'package:skin_firts/core/storage/data_state.dart';
import 'package:skin_firts/data/models/login_user_model/login_user_model.dart';

abstract class AuthFirebaseService {
  Future<DataState<LoginUserModel>> signIn(LoginUserModel loginUserModel);
}