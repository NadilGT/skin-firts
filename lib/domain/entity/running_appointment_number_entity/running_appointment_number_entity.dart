import 'package:equatable/equatable.dart';

class RunningAppointmentNumberEntity extends Equatable {
  final int running_appointment_number;

  const RunningAppointmentNumberEntity({required this.running_appointment_number});

  @override
  List<Object?> get props => [running_appointment_number];
}

class RunningAppointmentNumberParams extends Equatable {
  final String doctorId;
  final String date;

  const RunningAppointmentNumberParams({
    required this.doctorId,
    required this.date,
  });

  @override
  List<Object?> get props => [doctorId, date];
}
