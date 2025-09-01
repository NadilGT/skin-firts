import 'package:json_annotation/json_annotation.dart';
import 'package:skin_firts/domain/entity/doctor_entity/doctor_entity.dart';

part 'doctor_model.g.dart';

@JsonSerializable()
class DoctorModel extends DoctorEntity {
  
  const DoctorModel({
    required super.doctorName,
    required super.specialty,
    required super.profilePic,
    required super.rating,
    required super.reviewCount,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) => _$DoctorModelFromJson(json);
  Map<String, dynamic> toJson() => _$DoctorModelToJson(this);
}
