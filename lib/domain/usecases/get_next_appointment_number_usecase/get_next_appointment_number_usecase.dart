import 'package:skin_firts/core/storage/data_state.dart';
import 'package:skin_firts/data/models/next_appointment_number_model/next_appointment_number_model.dart';
import 'package:skin_firts/domain/usecases/usecase/usecase.dart';
import 'package:skin_firts/service_locator.dart';

import '../../repositories/appointment_repository/appointment_repository.dart';

class GetNextAppointmentNumberUsecase implements UseCase<DataState<NextAppointmentNumberModel>,Params>{
  @override
  Future<DataState<NextAppointmentNumberModel>> call({Params ? params}) {
    return sl<AppointmentRepository>().getNextAppointmentNumber(params!.doctorId, params.date);
  }
  
}

class Params {
  final String doctorId;
  final String date;

  Params({required this.doctorId, required this.date});
}