import 'package:skin_firts/core/storage/data_state.dart';

import '../../../data/models/appointment/appointment_model.dart';
import '../../../data/models/next_appointment_number_model/next_appointment_number_model.dart';
import '../../entity/appointment_entity/appointment_entity.dart';

abstract class AppointmentRepository  {
  Future<DataState<Appointment>> createAppointment(AppointmentModel appointment);
  Future<DataState<List<AppointmentModel>>> getAllAppointments();
  Future<DataState<NextAppointmentNumberModel>> getNextAppointmentNumber(
    String doctorId,
    String date,
  );
}