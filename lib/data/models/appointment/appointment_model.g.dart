// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentModel _$AppointmentModelFromJson(Map<String, dynamic> json) =>
    AppointmentModel(
      id: json['id'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      patientId: json['patientId'] as String,
      patientName: json['patientName'] as String,
      patientEmail: json['patientEmail'] as String,
      patientPhone: json['patientPhone'] as String?,
      doctorId: json['doctorId'] as String,
      doctorName: json['doctorName'] as String,
      doctorSpecialty: json['doctorSpecialty'] as String?,
      appointmentDate: DateTime.parse(json['appointmentDate'] as String),
      timeSlot: json['timeSlot'] as String,
      notes: json['notes'] as String?,
      status: json['status'] as String? ?? 'pending',
    );

Map<String, dynamic> _$AppointmentModelToJson(AppointmentModel instance) =>
    <String, dynamic>{
      'patientId': instance.patientId,
      'patientName': instance.patientName,
      'patientEmail': instance.patientEmail,
      'patientPhone': instance.patientPhone,
      'doctorId': instance.doctorId,
      'doctorName': instance.doctorName,
      'doctorSpecialty': instance.doctorSpecialty,
      'appointmentDate': instance.appointmentDate.toIso8601String(),
      'timeSlot': instance.timeSlot,
      'notes': instance.notes,
      'status': instance.status,
    };
