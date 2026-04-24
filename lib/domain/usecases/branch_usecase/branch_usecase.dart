import 'package:skin_firts/core/storage/data_state.dart';
import 'package:skin_firts/domain/repositories/branch_repository/branch_repository.dart';
import 'package:skin_firts/domain/usecases/usecase/usecase.dart';
import 'package:skin_firts/service_locator.dart';

class GetAllBranchesUsecase implements UseCase<DataState, String?> {
  @override
  Future<DataState> call({String? params}) {
    return sl<BranchRepository>().findAllBranches(params);
  }
}