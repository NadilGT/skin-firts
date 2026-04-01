import 'package:skin_firts/core/storage/data_state.dart';
import 'package:skin_firts/data/models/save_fcm_token_model/save_fcm_token_model.dart';

abstract class SaveFcmTokenRepository {
  Future<DataState<dynamic>> saveFcmToken(
    SaveFcmTokenModel saveFcmTokenModel,
  );
}