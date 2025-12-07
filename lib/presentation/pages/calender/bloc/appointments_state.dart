import 'package:equatable/equatable.dart';

import '../../../../data/models/appointment/appointment_model.dart';

abstract class AppointmentsState extends Equatable {
  const AppointmentsState();

  @override
  List<Object?> get props => [];
}

class AppointmentInitial extends AppointmentsState {}

class AppointmentLoading extends AppointmentsState {}

class AppointmentLoaded extends AppointmentsState {
  final List<AppointmentModel> appointments;

  const AppointmentLoaded({required this.appointments});

  @override
  List<Object?> get props => [appointments];
}

class AppointmentError extends AppointmentsState {
  final String message;

  const AppointmentError({required this.message});

  @override
  List<Object?> get props => [message];
}