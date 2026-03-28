import 'package:skin_firts/core/storage/data_state.dart';
import '../../../data/models/doctor_availability_model/doctor_availability_model.dart';
import '../../entity/doctor_availability_entity/doctor_availability_entity.dart';

abstract class DoctorAvailabilityRepository {
  Future<DataState<DoctorAvailabilityModel>> getDoctorAvailability(
    DoctorAvailabilityParams params,
  );
}