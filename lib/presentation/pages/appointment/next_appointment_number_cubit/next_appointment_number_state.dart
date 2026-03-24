import '../../../../data/models/next_appointment_number_model/next_appointment_number_model.dart';

abstract class NextAppointmentNumberState {}

class NextAppointmentNumberInitial extends NextAppointmentNumberState {}

class NextAppointmentNumberLoading extends NextAppointmentNumberState {}

class NextAppointmentNumberLoaded extends NextAppointmentNumberState {
  final NextAppointmentNumberModel nextAppointmentNumber;

  NextAppointmentNumberLoaded(this.nextAppointmentNumber);
}

class NextAppointmentNumberError extends NextAppointmentNumberState {
  final String error;

  NextAppointmentNumberError(this.error);
}