import 'package:skin_firts/core/storage/data_state.dart';
import 'package:skin_firts/data/models/doctor_schedule_model/doctor_schedule_model.dart';

abstract class DoctorScheduleRepository {
  Future<DataState<DoctorScheduleResponseModel>> getDoctorSchedule(String doctorId, String? branchId);
}