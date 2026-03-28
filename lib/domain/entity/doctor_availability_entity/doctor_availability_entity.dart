import 'package:equatable/equatable.dart';

class DoctorAvailabilityEntity extends Equatable {
  final String id;
  final String doctorAvailabilityId;
  final String doctorId;
  final String date;
  final bool isAvailable;
  final String? estimatedStartTime;
  final int? maxPatients;
  final String notes;
  final String createdAt;
  final String updatedAt;

  const DoctorAvailabilityEntity({
    required this.id,
    required this.doctorAvailabilityId,
    required this.doctorId,
    required this.date,
    required this.isAvailable,
    this.estimatedStartTime,
    this.maxPatients,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        doctorAvailabilityId,
        doctorId,
        date,
        isAvailable,
        estimatedStartTime,
        maxPatients,
        notes,
        createdAt,
        updatedAt,
      ];
}

class DoctorAvailabilityParams extends Equatable {
  final String doctorId;
  final String date;

  const DoctorAvailabilityParams({
    required this.doctorId,
    required this.date,
  });

  @override
  List<Object?> get props => [doctorId, date];
}