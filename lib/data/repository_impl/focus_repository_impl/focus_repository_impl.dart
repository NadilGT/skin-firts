import 'package:dio/dio.dart';
import 'package:skin_firts/core/storage/data_state.dart';
import 'package:skin_firts/data/models/focus_model/focus_model.dart';
import 'package:skin_firts/domain/repositories/focus_repository/focus_repository.dart';

import '../../../domain/service/api/api_service.dart';
import '../../../service_locator.dart';

class FocusRepositoryImpl extends FocusRepository {
  final ApiService apiService = sl<ApiService>();
  @override
  Future<DataState<List<FocusModel>>> getAllFocus() async {
    try {
      final httpResponse = await apiService.getAllFocus();
      print(httpResponse);
      if (httpResponse.response.statusCode == 200) {
        return DataSuccess(httpResponse.data);
      } else {
        print(httpResponse.response);
        return DataFailed("Data Fetching Failed");
      }
    } on DioException catch (e) {
      return DataFailed(e.toString());
    }
  }
}
