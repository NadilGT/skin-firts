import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_firts/presentation/pages/home/branch_cubit/branch_state.dart';

import '../../../../core/storage/data_state.dart';
import '../../../../domain/usecases/branch_usecase/branch_usecase.dart';
import '../../../../service_locator.dart';

class BranchCubit extends Cubit<BranchState>{
  BranchCubit() : super(BranchInitial());

  Future<void> getAllBranches()async{
    emit(BranchLoading());
    var result = await sl<GetAllBranchesUsecase>().call();
    print("branch cubit wada");
    if(result is DataSuccess){
      print("branch success");
      emit(BranchLoaded(branchResponseModel: result.data));
    }else if(result is DataFailed){
      print("branch failed");
      emit(BranchError(error: result.error ?? "error"));
    }
  }
}