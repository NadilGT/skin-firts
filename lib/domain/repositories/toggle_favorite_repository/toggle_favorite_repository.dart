import 'package:skin_firts/core/storage/data_state.dart';
import 'package:skin_firts/data/models/doctor_info_model/doctor_info_model.dart';

abstract class ToggleFavoriteRepository {
  Future<DataState<DoctorInfoModel>> toggleFavDoc(String name);
}