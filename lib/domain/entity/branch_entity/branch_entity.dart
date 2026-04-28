import 'package:equatable/equatable.dart';

class BranchEntity extends Equatable {
  final String id;
  final String branchId;
  final String name;
  final String address;
  final String phone;
  final String email;
  final bool isMainBranch;
  final String status;
  final String createdAt;
  final String updatedAt;

  const BranchEntity({
    required this.id,
    required this.branchId,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.isMainBranch,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        branchId,
        name,
        address,
        phone,
        email,
        isMainBranch,
        status,
        createdAt,
        updatedAt,
      ];
}

class BranchResponseEntity extends Equatable{
  final List<BranchEntity> data;

  const BranchResponseEntity({
    required this.data,
  });

  @override
  List<Object?> get props => [
    data,
  ];

  
}