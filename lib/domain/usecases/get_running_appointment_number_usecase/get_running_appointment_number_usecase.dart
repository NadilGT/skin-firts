import 'package:skin_firts/core/storage/data_state.dart';
import 'package:skin_firts/core/storage/shared_pref_manager.dart';
import 'package:skin_firts/domain/usecases/usecase/usecase.dart';
import 'package:skin_firts/service_locator.dart';

import '../../../data/models/running_appointment_number_model/running_appointment_number_model.dart';
import '../../repositories/appointment_repository/appointment_repository.dart';

class GetRunningAppointmentNumberUsecase
    extends
        UseCase<
          DataState<RunningAppointmentNumberModel>,
          RunningAppointmentNumberParamsModel
        > {
  @override
  Future<DataState<RunningAppointmentNumberModel>> call({
    RunningAppointmentNumberParamsModel? params,
  }) async {
    final branchId = await sl<SharedPrefManager>().getBranchId();
    return sl<AppointmentRepository>().getRunningAppointmentNumber(
      params!.doctorId,
      params.date,
      branchId,
    );
  }
}
