import 'package:dio/dio.dart';
import 'package:skin_firts/core/storage/data_state.dart';
import 'package:skin_firts/data/models/doctor_schedule_model/doctor_schedule_model.dart';
import 'package:skin_firts/domain/repositories/doctor_schedule_repository/doctor_schedule_repository.dart';

import '../../../domain/service/api/api_service.dart';
import '../../../service_locator.dart';

class DoctorScheduleRepositoryImpl extends DoctorScheduleRepository {
  final ApiService apiService = sl<ApiService>();
  @override
  Future<DataState<DoctorScheduleResponseModel>> getDoctorSchedule(String doctorId, String? branchId) async{
    try{
      final httpResponse = await apiService.getDoctorSchedule(doctorId, branchId);
      if(httpResponse.response.statusCode == 200){
        return DataSuccess(httpResponse.data);
      } else {
        return DataFailed("Data Fetching Failed");
      }
    } on DioException catch(e) {
      return DataFailed(e.response.toString());
    }
  }
}