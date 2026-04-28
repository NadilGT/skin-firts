import 'package:skin_firts/core/storage/data_state.dart';
import 'package:skin_firts/core/storage/shared_pref_manager.dart';
import 'package:skin_firts/domain/usecases/usecase/usecase.dart';
import 'package:skin_firts/service_locator.dart';

import '../../repositories/doctor_schedule_repository/doctor_schedule_repository.dart';

class GetDoctorScheduleUsecase extends UseCase<DataState, String> {
  @override
  Future<DataState> call({String? params}) async {
    final branchId = await sl<SharedPrefManager>().getBranchId();
    return sl<DoctorScheduleRepository>().getDoctorSchedule(params!, branchId);
  }
}
