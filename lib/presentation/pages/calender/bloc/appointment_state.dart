import 'package:skin_firts/domain/entity/appointment_entity/appointment_entity.dart';

abstract class AppointmentState {}

class AppointmentInitial extends AppointmentState {}

class AppointmentLoading extends AppointmentState {}

class AppointmentCreated extends AppointmentState {
  final Appointment appointment;
  AppointmentCreated({required this.appointment});
}

class AppointmentsFetched extends AppointmentState {
  final List<Appointment> appointments;
  AppointmentsFetched({required this.appointments});
}

class AppointmentCancelled extends AppointmentState {
  final String message;
  AppointmentCancelled({required this.message});
}

class AppointmentFailed extends AppointmentState {
  final String error;
  AppointmentFailed({required this.error});
}