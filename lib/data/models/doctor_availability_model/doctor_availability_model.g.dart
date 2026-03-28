// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_availability_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorAvailabilityModel _$DoctorAvailabilityModelFromJson(
  Map<String, dynamic> json,
) => DoctorAvailabilityModel(
  id: json['id'] as String,
  doctorAvailabilityId: json['doctorAvailabilityId'] as String,
  doctorId: json['doctorId'] as String,
  date: json['date'] as String,
  isAvailable: json['isAvailable'] as bool,
  estimatedStartTime: json['estimatedStartTime'] as String,
  maxPatients: (json['maxPatients'] as num).toInt(),
  notes: json['notes'] as String,
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
);

Map<String, dynamic> _$DoctorAvailabilityModelToJson(
  DoctorAvailabilityModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'doctorAvailabilityId': instance.doctorAvailabilityId,
  'doctorId': instance.doctorId,
  'date': instance.date,
  'isAvailable': instance.isAvailable,
  'estimatedStartTime': instance.estimatedStartTime,
  'maxPatients': instance.maxPatients,
  'notes': instance.notes,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};

DoctorAvailabilityParamsModel _$DoctorAvailabilityParamsModelFromJson(
  Map<String, dynamic> json,
) => DoctorAvailabilityParamsModel(
  doctorId: json['doctorId'] as String,
  date: json['date'] as String,
);

Map<String, dynamic> _$DoctorAvailabilityParamsModelToJson(
  DoctorAvailabilityParamsModel instance,
) => <String, dynamic>{'doctorId': instance.doctorId, 'date': instance.date};
