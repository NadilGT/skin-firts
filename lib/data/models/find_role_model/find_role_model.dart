import 'package:json_annotation/json_annotation.dart';
import 'package:skin_firts/domain/entity/find_role_entity/find_role_entity.dart';

part 'find_role_model.g.dart';

@JsonSerializable()
class FindRoleModel extends FindRoleEntity{
  const FindRoleModel({required super.firebaseUid});

  factory FindRoleModel.fromJson(Map<String, dynamic> json) => _$FindRoleModelFromJson(json);
  Map<String, dynamic> toJson() => _$FindRoleModelToJson(this);
}

@JsonSerializable()
class FindRoleResponseModel extends FindRoleResponseEntity{
  const FindRoleResponseModel({required super.firebaseUid, required super.role});

  factory FindRoleResponseModel.fromJson(Map<String, dynamic> json) => _$FindRoleResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$FindRoleResponseModelToJson(this);

  
}