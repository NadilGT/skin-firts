import 'package:skin_firts/core/storage/data_state.dart';
import 'package:skin_firts/data/models/login_user_model/login_user_model.dart';
import 'package:skin_firts/domain/repositories/auth/auth_firebase_service.dart';
import 'package:skin_firts/domain/usecases/usecase/usecase.dart';
import 'package:skin_firts/service_locator.dart';

class LoginUseCase implements UseCase<DataState,LoginUserModel> {
  
  @override
  Future<DataState> call({LoginUserModel ? params}) async {
    return sl<AuthFirebaseService>().signIn(params!);
  }

}