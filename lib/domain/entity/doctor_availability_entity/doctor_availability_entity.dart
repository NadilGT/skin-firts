import 'package:equatable/equatable.dart';

class DoctorAvailabilityEntity extends Equatable {
  final String? id;
  final String? doctorAvailabilityId;
  final String doctorId;
  final String date;
  final bool isAvailable;
  final String? estimatedStartTime;
  final int? maxPatients;
  final String notes;
  final String? createdAt;
  final String? updatedAt;

  const DoctorAvailabilityEntity({
    this.id,
    this.doctorAvailabilityId,
    required this.doctorId,
    required this.date,
    required this.isAvailable,
    this.estimatedStartTime,
    this.maxPatients,
    required this.notes,
    this.createdAt,
    this.updatedAt,
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
  final String? branchId;

  const DoctorAvailabilityParams({
    required this.doctorId,
    required this.date,
    this.branchId,
  });

  @override
  List<Object?> get props => [doctorId, date, branchId];
}