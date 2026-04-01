import 'package:json_annotation/json_annotation.dart';
import 'package:skin_firts/domain/entity/doctor_schedule_entity/doctor_schedule_entity.dart';

part 'doctor_schedule_model.g.dart';

@JsonSerializable()
class DoctorScheduleResponseModel extends DoctorScheduleResponseEntity {
  @override
  final List<DoctorScheduleModel> availableDates;

  const DoctorScheduleResponseModel({
    required this.availableDates,
  }) : super(availableDates: availableDates);

  factory DoctorScheduleResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorScheduleResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$DoctorScheduleResponseModelToJson(this);
}

@JsonSerializable()
class DoctorScheduleModel extends DoctorScheduleEntity {
  const DoctorScheduleModel({
    required super.date,
    required super.dayOfWeek,
    required super.dayName,
    required super.defaultStartTime,
  });

  factory DoctorScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorScheduleModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$DoctorScheduleModelToJson(this);
}