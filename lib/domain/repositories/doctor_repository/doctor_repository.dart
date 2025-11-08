import 'package:skin_firts/core/storage/data_state.dart';

import '../../../data/models/doctor_info_model/doctor_info_model.dart';

abstract class DoctorRepository {
  Future<DataState<List<DoctorInfoModel>>> getAllDoctors();
}