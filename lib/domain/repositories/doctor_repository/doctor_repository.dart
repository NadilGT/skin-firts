import 'package:skin_firts/core/storage/data_state.dart';
import 'package:skin_firts/data/models/doctor_model/doctor_model.dart';

abstract class DoctorRepository {
  Future<DataState<List<DoctorModel>>> getAllDoctors();
}