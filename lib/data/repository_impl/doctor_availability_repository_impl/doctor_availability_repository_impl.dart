import 'package:skin_firts/core/storage/data_state.dart';
import 'package:skin_firts/domain/entity/doctor_availability_entity/doctor_availability_entity.dart';
import 'package:skin_firts/domain/repositories/doctor_availability_repository/doctor_availability_repository.dart';
import 'package:skin_firts/domain/service/api/api_service.dart';
import 'package:skin_firts/service_locator.dart';

import '../../models/doctor_availability_model/doctor_availability_model.dart';

class DoctorAvailabilityRepositoryImpl extends DoctorAvailabilityRepository {
  final ApiService _apiService = sl<ApiService>();
  @override
  Future<DataState<DoctorAvailabilityModel>> getDoctorAvailability(
    DoctorAvailabilityParams params,
  ) async {
    try {
      final httpResponse = await _apiService.getDoctorAvailability(
        params.doctorId,
        params.date,
      );
      if (httpResponse.response.statusCode == 200) {
        return DataSuccess(httpResponse.data);
      } else {
        return DataFailed(httpResponse.response.data.toString());
      }
    } catch (e) {
      return DataFailed(e.toString());
    }
  }
}