import 'package:skin_firts/core/storage/data_state.dart';
import 'package:skin_firts/core/storage/shared_pref_manager.dart';
import 'package:skin_firts/domain/entity/doctor_availability_entity/doctor_availability_entity.dart';
import 'package:skin_firts/domain/repositories/doctor_availability_repository/doctor_availability_repository.dart';
import '../../../service_locator.dart';
import '../usecase/usecase.dart';

class GetDoctorAvailabilityUsecase extends UseCase<DataState, DoctorAvailabilityParams> {
  @override
  Future<DataState> call({DoctorAvailabilityParams? params}) async {
    final branchId = await sl<SharedPrefManager>().getBranchId();
    final updatedParams = DoctorAvailabilityParams(
      doctorId: params!.doctorId,
      date: params.date,
      branchId: branchId,
    );
    return sl<DoctorAvailabilityRepository>().getDoctorAvailability(updatedParams);
  }
}