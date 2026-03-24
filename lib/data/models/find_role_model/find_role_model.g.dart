// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'find_role_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FindRoleModel _$FindRoleModelFromJson(Map<String, dynamic> json) =>
    FindRoleModel(firebaseUid: json['firebaseUid'] as String);

Map<String, dynamic> _$FindRoleModelToJson(FindRoleModel instance) =>
    <String, dynamic>{'firebaseUid': instance.firebaseUid};

FindRoleResponseModel _$FindRoleResponseModelFromJson(
  Map<String, dynamic> json,
) => FindRoleResponseModel(
  firebaseUid: json['firebaseUid'] as String,
  role: json['role'] as String,
);

Map<String, dynamic> _$FindRoleResponseModelToJson(
  FindRoleResponseModel instance,
) => <String, dynamic>{
  'firebaseUid': instance.firebaseUid,
  'role': instance.role,
};
