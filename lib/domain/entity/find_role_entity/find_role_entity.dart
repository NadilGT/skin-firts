import 'package:equatable/equatable.dart';

class FindRoleEntity extends Equatable{
  final String firebaseUid;
  const FindRoleEntity({required this.firebaseUid});
  @override
  List<Object?> get props => [firebaseUid];
}

class FindRoleResponseEntity extends Equatable{
  final String firebaseUid;
  final String role;
  const FindRoleResponseEntity({required this.firebaseUid, required this.role});
  @override
  List<Object?> get props => [firebaseUid, role];
}
