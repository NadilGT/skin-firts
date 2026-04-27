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
      appointmentId: json['appointmentId'] as String,
      appointmentNumber: (json['appointmentNumber'] as num).toInt(),
      patientId: json['patientId'] as String,
      patientName: json['patientName'] as String,
      patientEmail: json['patientEmail'] as String,
      patientPhone: json['patientPhone'] as String?,
      doctorId: json['doctorId'] as String,
      doctorName: json['doctorName'] as String,
      doctorSpecialty: json['doctorSpecialty'] as String?,
      appointmentDate: _dateFromJson(json['appointmentDate'] as String),
      notes: json['notes'] as String?,
      status: json['status'] as String? ?? 'pending',
      branchId: json['branchId'] as String?,
    );

Map<String, dynamic> _$AppointmentModelToJson(AppointmentModel instance) =>
    <String, dynamic>{
      'appointmentId': instance.appointmentId,
      'appointmentNumber': instance.appointmentNumber,
      'patientId': instance.patientId,
      'patientName': instance.patientName,
      'patientEmail': instance.patientEmail,
      'patientPhone': instance.patientPhone,
      'doctorId': instance.doctorId,
      'doctorName': instance.doctorName,
      'doctorSpecialty': instance.doctorSpecialty,
      'notes': instance.notes,
      'status': instance.status,
      'branchId': instance.branchId,
      'appointmentDate': _dateToJson(instance.appointmentDate),
    };
