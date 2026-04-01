import 'package:skin_firts/core/storage/data_state.dart';
import 'package:skin_firts/data/models/save_fcm_token_model/save_fcm_token_model.dart';
import 'package:skin_firts/domain/repositories/save_fcm_token_repositoy/save_fcm_token_repositoy.dart';
import 'package:skin_firts/domain/usecases/usecase/usecase.dart';
import 'package:skin_firts/service_locator.dart';

class SaveFcmTokenUseCase implements UseCase<DataState<dynamic>,SaveFcmTokenModel> {
  @override
  Future<DataState<dynamic>> call({SaveFcmTokenModel ? params}) async {
    return sl<SaveFcmTokenRepository>().saveFcmToken(params!);
  }
}