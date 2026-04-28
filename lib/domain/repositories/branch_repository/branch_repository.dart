import '../../../core/storage/data_state.dart';
import '../../../data/models/branch_model/branch_model.dart';

abstract class BranchRepository {
  Future<DataState<BranchResponseModel>> findAllBranches(String? status);
}