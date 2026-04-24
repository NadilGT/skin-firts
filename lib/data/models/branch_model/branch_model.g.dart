// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BranchModel _$BranchModelFromJson(Map<String, dynamic> json) => BranchModel(
  id: json['id'] as String,
  branchId: json['branchId'] as String,
  name: json['name'] as String,
  address: json['address'] as String,
  phone: json['phone'] as String,
  email: json['email'] as String,
  isMainBranch: json['isMainBranch'] as bool,
  status: json['status'] as String,
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
);

Map<String, dynamic> _$BranchModelToJson(BranchModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'branchId': instance.branchId,
      'name': instance.name,
      'address': instance.address,
      'phone': instance.phone,
      'email': instance.email,
      'isMainBranch': instance.isMainBranch,
      'status': instance.status,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

BranchResponseModel _$BranchResponseModelFromJson(Map<String, dynamic> json) =>
    BranchResponseModel(
      data: (json['data'] as List<dynamic>)
          .map((e) => BranchModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BranchResponseModelToJson(
  BranchResponseModel instance,
) => <String, dynamic>{'data': instance.data};
