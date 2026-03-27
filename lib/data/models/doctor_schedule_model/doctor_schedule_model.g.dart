// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorScheduleResponseModel _$DoctorScheduleResponseModelFromJson(
  Map<String, dynamic> json,
) => DoctorScheduleResponseModel(
  availableDates: (json['availableDates'] as List<dynamic>)
      .map((e) => DoctorScheduleModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DoctorScheduleResponseModelToJson(
  DoctorScheduleResponseModel instance,
) => <String, dynamic>{'availableDates': instance.availableDates};

DoctorScheduleModel _$DoctorScheduleModelFromJson(Map<String, dynamic> json) =>
    DoctorScheduleModel(
      date: json['date'] as String,
      dayOfWeek: (json['dayOfWeek'] as num).toInt(),
      dayName: json['dayName'] as String,
      defaultStartTime: json['defaultStartTime'] as String,
    );

Map<String, dynamic> _$DoctorScheduleModelToJson(
  DoctorScheduleModel instance,
) => <String, dynamic>{
  'date': instance.date,
  'dayOfWeek': instance.dayOfWeek,
  'dayName': instance.dayName,
  'defaultStartTime': instance.defaultStartTime,
};
