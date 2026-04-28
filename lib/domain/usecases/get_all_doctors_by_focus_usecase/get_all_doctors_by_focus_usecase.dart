import 'package:skin_firts/core/storage/data_state.dart';
import 'package:skin_firts/core/storage/shared_pref_manager.dart';
import 'package:skin_firts/domain/repositories/doctor_info_repository/doctor_info_repository.dart';
import 'package:skin_firts/service_locator.dart';

import '../usecase/usecase.dart';

class GetAllDoctorsByFocusUseCase implements UseCase<DataState, String>{
  @override
  Future<DataState> call({String? params}) async {
    final branchId = await sl<SharedPrefManager>().getBranchId();
    return sl<DoctorInfoRepository>().getAllDoctorsByFocus(params!, branchId);
  }
}