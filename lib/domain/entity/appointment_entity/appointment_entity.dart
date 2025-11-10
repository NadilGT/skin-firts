import 'package:equatable/equatable.dart';

class Appointment extends Equatable {
  final String patientId;
  final String patientName;
  final String patientEmail;
  final String? patientPhone;
  final String doctorId;
  final String doctorName;
  final String? doctorSpecialty;
  final DateTime appointmentDate;
  final String timeSlot;
  final String? notes;
  final String status;

  const Appointment({
    required this.patientId,
    required this.patientName,
    required this.patientEmail,
    this.patientPhone,
    required this.doctorId,
    required this.doctorName,
    this.doctorSpecialty,
    required this.appointmentDate,
    required this.timeSlot,
    this.notes,
    this.status = 'pending',
  });

  @override
  List<Object?> get props => [
    patientId,
    patientName,
    patientEmail,
    patientPhone,
    doctorId,
    doctorName,
    doctorSpecialty,
    appointmentDate,
    timeSlot,
    notes,
    status,
  ];
}