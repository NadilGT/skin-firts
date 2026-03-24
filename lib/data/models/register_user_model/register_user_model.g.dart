// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterUserModel _$RegisterUserModelFromJson(Map<String, dynamic> json) =>
    RegisterUserModel(
      firebaseUid: json['firebaseUid'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
    );

Map<String, dynamic> _$RegisterUserModelToJson(RegisterUserModel instance) =>
    <String, dynamic>{
      'firebaseUid': instance.firebaseUid,
      'name': instance.name,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
    };

RegisterUserResponseModel _$RegisterUserResponseModelFromJson(
  Map<String, dynamic> json,
) => RegisterUserResponseModel(
  userId: json['userId'] as String,
  firebaseUid: json['firebaseUid'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  phoneNumber: json['phoneNumber'] as String,
  role: json['role'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$RegisterUserResponseModelToJson(
  RegisterUserResponseModel instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'firebaseUid': instance.firebaseUid,
  'name': instance.name,
  'email': instance.email,
  'phoneNumber': instance.phoneNumber,
  'role': instance.role,
  'createdAt': instance.createdAt.toIso8601String(),
};
