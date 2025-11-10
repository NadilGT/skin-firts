import 'package:skin_firts/core/storage/data_state.dart';

import '../../../data/models/appointment/appointment_model.dart';
import '../../entity/appointment_entity/appointment_entity.dart';

abstract class AppointmentRepository  {
  Future<DataState<Appointment>> createAppointment(AppointmentModel appointment);
}