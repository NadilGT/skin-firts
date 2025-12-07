import 'package:skin_firts/core/storage/data_state.dart';
import 'package:skin_firts/data/models/sign_up_user_model/sign_up_user_model.dart';
import 'package:skin_firts/domain/repositories/auth/auth_firebase_service.dart';
import 'package:skin_firts/domain/usecases/usecase/usecase.dart';
import 'package:skin_firts/service_locator.dart';

class SignUpUseCase implements UseCase<DataState,SignUpUserModel> {
  
  @override
  Future<DataState> call({SignUpUserModel ? params}) async {
    return sl<AuthFirebaseService>().signUp(params!);
  }

}
