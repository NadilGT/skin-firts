import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entity/branch_entity/branch_entity.dart';

part 'branch_model.g.dart';

@JsonSerializable()
class BranchModel extends BranchEntity {
  const BranchModel({
    required super.id,
    required super.branchId,
    required super.name,
    required super.address,
    required super.phone,
    required super.email,
    required super.isMainBranch,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) =>
      _$BranchModelFromJson(json);

  Map<String, dynamic> toJson() => _$BranchModelToJson(this);
}

@JsonSerializable()
class BranchResponseModel {
  final List<BranchModel> data;

  const BranchResponseModel({required this.data});

  factory BranchResponseModel.fromJson(Map<String, dynamic> json) =>
      _$BranchResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$BranchResponseModelToJson(this);
}

