import 'package:dio/dio.dart';
import 'package:skin_firts/core/storage/data_state.dart';
import 'package:skin_firts/data/models/doctor_info_model/doctor_info_model.dart';
import 'package:skin_firts/domain/repositories/toggle_favorite_repository/toggle_favorite_repository.dart';
import 'package:skin_firts/domain/service/api/api_service.dart';
import 'package:skin_firts/service_locator.dart';

class ToggleFavoriteRepositoryImpl extends ToggleFavoriteRepository{
  final ApiService apiService = sl<ApiService>();
  @override
  Future<DataState<DoctorInfoModel>> toggleFavDoc(String name)async{
    print("toggle repo wada sudda");
    try{
      final httpResponse = await apiService.toggleFavorite(name);
      print(httpResponse);
      if(httpResponse.response.statusCode == 200){
        return DataSuccess(httpResponse.data);
      } else {
        print(httpResponse.response);
        return DataFailed("Toggle Failed");
      }
    } on DioException catch(e){
      return DataFailed(e.response.toString());
    }
  }
}