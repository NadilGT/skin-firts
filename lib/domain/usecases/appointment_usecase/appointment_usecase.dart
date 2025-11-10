import 'package:skin_firts/core/storage/data_state.dart';
import 'package:skin_firts/domain/repositories/appointment_repository/appointment_repository.dart';
import 'package:skin_firts/domain/usecases/usecase/usecase.dart';
import 'package:skin_firts/service_locator.dart';

import '../../../data/models/appointment/appointment_model.dart';

class AppointmentUsecase implements UseCase<DataState, AppointmentModel>{
  @override
  Future<DataState> call({AppointmentModel? params}) {
    return sl<AppointmentRepository>().createAppointment(params!);
  }

}