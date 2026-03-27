import 'package:equatable/equatable.dart';

class DoctorScheduleEntity extends Equatable {
  final String date;
  final int dayOfWeek;
  final String dayName;
  final String defaultStartTime;

  const DoctorScheduleEntity({
    required this.date,
    required this.dayOfWeek,
    required this.dayName,
    required this.defaultStartTime,
  });

  @override
  List<Object?> get props => [
        date,
        dayOfWeek,
        dayName,
        defaultStartTime,
      ];
}

class DoctorScheduleResponseEntity extends Equatable {
  final List<DoctorScheduleEntity> availableDates;

  const DoctorScheduleResponseEntity({
    required this.availableDates,
  });

  @override
  List<Object?> get props => [availableDates];
}