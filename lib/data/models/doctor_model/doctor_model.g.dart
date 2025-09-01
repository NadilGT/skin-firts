// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorModel _$DoctorModelFromJson(Map<String, dynamic> json) => DoctorModel(
  doctorName: json['doctorName'] as String,
  specialty: json['specialty'] as String,
  profilePic: json['profilePic'] as String,
  rating: (json['rating'] as num).toDouble(),
  reviewCount: (json['reviewCount'] as num).toInt(),
);

Map<String, dynamic> _$DoctorModelToJson(DoctorModel instance) =>
    <String, dynamic>{
      'doctorName': instance.doctorName,
      'specialty': instance.specialty,
      'profilePic': instance.profilePic,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
    };
