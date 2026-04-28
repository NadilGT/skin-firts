import 'package:dio/dio.dart';
import 'package:skin_firts/domain/repositories/branch_repository/branch_repository.dart';
import 'package:skin_firts/domain/service/api/api_service.dart';

import '../../../core/storage/data_state.dart';
import '../../../service_locator.dart';
import '../../models/branch_model/branch_model.dart';

class BranchRepositoryImpl extends BranchRepository{
  final ApiService apiService = sl<ApiService>();

  @override
  Future<DataState<BranchResponseModel>> findAllBranches(String? status)async{
    try {
      final response = await apiService.findAllBranches(status);
      if(response.response.statusCode == 200){
        return DataSuccess(response.data);
      }else{
        return DataFailed(
          'Failed to fetch branches - Status: ${response.response.statusCode} - ${response.response.statusMessage ?? ''}',
        );
      }
    }on DioException catch (e) {
      return DataFailed(
        e.response?.data?.toString() ?? e.message ?? "Unknown error",
      );
    } catch (e) {
      return DataFailed(e.toString());
    }
  }
}