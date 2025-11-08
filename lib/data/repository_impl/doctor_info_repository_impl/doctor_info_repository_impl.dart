import 'package:dio/dio.dart';
import 'package:skin_firts/core/storage/data_state.dart';
import 'package:skin_firts/data/models/doctor_info_model/doctor_info_model.dart';
import 'package:skin_firts/domain/repositories/doctor_info_repository/doctor_info_repository.dart';

import '../../../domain/service/api/api_service.dart';
import '../../../service_locator.dart';

class DoctorInfoRepositoryImpl extends DoctorInfoRepository{
  final ApiService apiService = sl<ApiService>();
  @override
  Future<DataState<DoctorInfoModel>> getDoctorInfo(String name)async{
    print("info repo wada");
    try{
      final httpResponse = await apiService.getDoctorInfo(name);
      print(httpResponse);
      if(httpResponse.response.statusCode == 200){
        return DataSuccess(httpResponse.data);
      } else {
        print(httpResponse.response);
        return DataFailed("Data Fetching Failed");
      }
    } on DioException catch(e) {
      return DataFailed(e.response.toString());
    }
  }
}