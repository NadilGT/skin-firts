import 'package:skin_firts/data/models/running_appointment_number_model/running_appointment_number_model.dart';

class GetRunningAppointmentNumberState {}

class GetRunningAppointmentNumberInitial extends GetRunningAppointmentNumberState {}

class GetRunningAppointmentNumberLoading extends GetRunningAppointmentNumberState {}

class GetRunningAppointmentNumberLoaded extends GetRunningAppointmentNumberState {
  final RunningAppointmentNumberModel runningAppointmentNumber;
  GetRunningAppointmentNumberLoaded(this.runningAppointmentNumber);
}

class GetRunningAppointmentNumberError extends GetRunningAppointmentNumberState {
  final String error;
  GetRunningAppointmentNumberError(this.error);
}