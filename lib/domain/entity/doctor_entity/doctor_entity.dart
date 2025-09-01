import 'package:equatable/equatable.dart';

class DoctorEntity extends Equatable {
  final String doctorName;
  final String specialty;
  final String profilePic;
  final double rating;
  final int reviewCount;

  const DoctorEntity({
    required this.doctorName,
    required this.specialty,
    required this.profilePic,
    required this.rating,
    required this.reviewCount,
  });

  @override
  List<Object?> get props => [
    doctorName,
    specialty,
    profilePic,
    rating,
    reviewCount
  ];
}
