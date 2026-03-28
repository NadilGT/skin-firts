import 'package:json_annotation/json_annotation.dart';
import 'package:skin_firts/domain/entity/doctor_availability_entity/doctor_availability_entity.dart';

part 'doctor_availability_model.g.dart';

@JsonSerializable()
class DoctorAvailabilityModel extends DoctorAvailabilityEntity {
  const DoctorAvailabilityModel({
    required super.id,
    required super.doctorAvailabilityId,
    required super.doctorId,
    required super.date,
    required super.isAvailable,
    required super.estimatedStartTime,
    required super.maxPatients,
    required super.notes,
    required super.createdAt,
    required super.updatedAt,
  });

  factory DoctorAvailabilityModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorAvailabilityModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$DoctorAvailabilityModelToJson(this);
}

@JsonSerializable()
class DoctorAvailabilityParamsModel extends DoctorAvailabilityParams {
  const DoctorAvailabilityParamsModel({
    required super.doctorId,
    required super.date,
  });

  factory DoctorAvailabilityParamsModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorAvailabilityParamsModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$DoctorAvailabilityParamsModelToJson(this);
}