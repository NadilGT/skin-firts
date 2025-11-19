import 'package:skin_firts/core/storage/data_state.dart';
import 'package:skin_firts/domain/repositories/appointment_repository/appointment_repository.dart';
import 'package:skin_firts/domain/usecases/usecase/usecase.dart';
import 'package:skin_firts/service_locator.dart';

class GetAllAppointmentsUsecase implements UseCase<DataState, void> {
  @override
  Future<DataState> call({void params}) {
    return sl<AppointmentRepository>().getAllAppointments();
  }
}
