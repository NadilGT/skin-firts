// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'running_appointment_number_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RunningAppointmentNumberModel _$RunningAppointmentNumberModelFromJson(
  Map<String, dynamic> json,
) => RunningAppointmentNumberModel(
  running_appointment_number: (json['running_appointment_number'] as num)
      .toInt(),
);

Map<String, dynamic> _$RunningAppointmentNumberModelToJson(
  RunningAppointmentNumberModel instance,
) => <String, dynamic>{
  'running_appointment_number': instance.running_appointment_number,
};

RunningAppointmentNumberParamsModel
_$RunningAppointmentNumberParamsModelFromJson(Map<String, dynamic> json) =>
    RunningAppointmentNumberParamsModel(
      doctorId: json['doctorId'] as String,
      date: json['date'] as String,
    );

Map<String, dynamic> _$RunningAppointmentNumberParamsModelToJson(
  RunningAppointmentNumberParamsModel instance,
) => <String, dynamic>{'doctorId': instance.doctorId, 'date': instance.date};
