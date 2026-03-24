import 'package:equatable/equatable.dart';

class RegisterUserEntity extends Equatable {
  final String firebaseUid;
  final String name;
  final String email;
  final String phoneNumber;

  const RegisterUserEntity({
    required this.firebaseUid,
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [
    firebaseUid,
    name,
    email,
    phoneNumber,
  ];
}

class RegisterUserResponseEntity extends Equatable {
  final String userId;
  final String firebaseUid;
  final String name;
  final String email;
  final String phoneNumber;
  final String role;
  final DateTime createdAt;

  const RegisterUserResponseEntity({
    required this.userId,
    required this.firebaseUid,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.role,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    userId,
    firebaseUid,
    name,
    email,
    phoneNumber,
    role,
    createdAt,
  ];
}
