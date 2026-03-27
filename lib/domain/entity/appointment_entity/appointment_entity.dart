import 'package:equatable/equatable.dart';

class Appointment extends Equatable {
  final String appointmentId;
  final int appointmentNumber;
  final String patientId;
  final String patientName;
  final String patientEmail;
  final String? patientPhone;
  final String doctorId;
  final String doctorName;
  final String? doctorSpecialty;
  final DateTime appointmentDate;
  final String? notes;
  final String status;

  const Appointment({
    required this.appointmentId,
    required this.appointmentNumber,
    required this.patientId,
    required this.patientName,
    required this.patientEmail,
    this.patientPhone,
    required this.doctorId,
    required this.doctorName,
    this.doctorSpecialty,
    required this.appointmentDate,
    this.notes,
    this.status = 'pending',
  });

  @override
  List<Object?> get props => [
    appointmentId,
    appointmentNumber,
    patientId,
    patientName,
    patientEmail,
    patientPhone,
    doctorId,
    doctorName,
    doctorSpecialty,
    appointmentDate,
    notes,
    status,
  ];
}

class PaginatedAppointments extends Equatable {
  final List<Appointment> data;
  final int limit;
  final int page;
  final int total;
  final int totalPages;

  const PaginatedAppointments({
    required this.data,
    required this.limit,
    required this.page,
    required this.total,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [data, limit, page, total, totalPages];
}