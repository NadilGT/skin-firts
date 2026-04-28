import '../../../../data/models/branch_model/branch_model.dart';

abstract class BranchState {}

class BranchInitial extends BranchState{}
class BranchLoading extends BranchState{}
class BranchLoaded extends BranchState{
  final BranchResponseModel branchResponseModel;
  BranchLoaded({required this.branchResponseModel});
}
class BranchError extends BranchState{
  final String error;
  BranchError({required this.error});
}
