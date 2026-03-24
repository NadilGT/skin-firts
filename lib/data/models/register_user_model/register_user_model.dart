import 'package:json_annotation/json_annotation.dart';
import 'package:skin_firts/domain/entity/register_user_entity/register_user_entity.dart';

part 'register_user_model.g.dart';

@JsonSerializable()
class RegisterUserModel extends RegisterUserEntity {
  const RegisterUserModel({
    required super.firebaseUid,
    required super.name,
    required super.email,
    required super.phoneNumber,
  });

  factory RegisterUserModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterUserModelToJson(this);
}

@JsonSerializable()
class RegisterUserResponseModel extends RegisterUserResponseEntity {
  const RegisterUserResponseModel({
    required super.userId,
    required super.firebaseUid,
    required super.name,
    required super.email,
    required super.phoneNumber,
    required super.role,
    required super.createdAt,
  });

  factory RegisterUserResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterUserResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterUserResponseModelToJson(this);
}