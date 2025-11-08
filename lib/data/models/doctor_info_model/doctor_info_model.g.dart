// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorInfoModel _$DoctorInfoModelFromJson(Map<String, dynamic> json) =>
    DoctorInfoModel(
      name: json['name'] as String,
      experience: (json['experience'] as num).toInt(),
      focus: json['focus'] as String,
      special: json['special'] as String,
      starts: (json['starts'] as num).toInt(),
      messages: (json['messages'] as num).toInt(),
      date: json['date'] as String,
      profile: json['profile'] as String,
      career: json['career'] as String,
      highlights: json['highlights'] as String,
      favorite: json['favorite'] as bool,
      profilePic: json['profilePic'] as String,
    );

Map<String, dynamic> _$DoctorInfoModelToJson(DoctorInfoModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'experience': instance.experience,
      'focus': instance.focus,
      'special': instance.special,
      'starts': instance.starts,
      'messages': instance.messages,
      'date': instance.date,
      'profile': instance.profile,
      'career': instance.career,
      'highlights': instance.highlights,
      'favorite': instance.favorite,
      'profilePic': instance.profilePic,
    };
