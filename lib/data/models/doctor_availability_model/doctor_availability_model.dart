import 'package:json_annotation/json_annotation.dart';
import 'package:skin_firts/domain/entity/doctor_availability_entity/doctor_availability_entity.dart';

part 'doctor_availability_model.g.dart';

@JsonSerializable()
class DoctorAvailabilityModel extends DoctorAvailabilityEntity {
  const DoctorAvailabilityModel({
    super.id,
    super.doctorAvailabilityId,
    required super.doctorId,
    required super.date,
    required super.isAvailable,
    super.estimatedStartTime,
    super.maxPatients,
    required super.notes,
    super.createdAt,
    super.updatedAt,
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
    super.branchId,
  });

  factory DoctorAvailabilityParamsModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorAvailabilityParamsModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$DoctorAvailabilityParamsModelToJson(this);
}