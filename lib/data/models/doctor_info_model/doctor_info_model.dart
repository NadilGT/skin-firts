import 'package:json_annotation/json_annotation.dart';
import 'package:skin_firts/domain/entity/doctor_info_entity/doctor_info_entity.dart';

part 'doctor_info_model.g.dart';

@JsonSerializable()
class DoctorInfoModel extends DoctorInfoEntity {

  const DoctorInfoModel({
    required super.name,
    required super.experience,
    required super.focus,
    required super.special,
    required super.starts,
    required super.messages,
    required super.date,
    required super.profile,
    required super.career,
    required super.highlights,
  });

  factory DoctorInfoModel.fromJson(Map<String, dynamic> json) => _$DoctorInfoModelFromJson(json);
  Map<String, dynamic> toJson() => _$DoctorInfoModelToJson(this);
}
