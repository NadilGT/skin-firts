import 'package:equatable/equatable.dart';

class DoctorInfoEntity extends Equatable{
  final String doctor_id;
  final String name;
  final int experience;
  final String focus;
  final String special;
  final int starts;
  final int messages;
  final String date;
  final String profile;
  final String career;
  final String highlights;
  final bool favorite;
  final String profile_pic;

  const DoctorInfoEntity({
    required this.doctor_id,
    required this.name,
    required this.experience,
    required this.focus,
    required this.special,
    required this.starts,
    required this.messages,
    required this.date,
    required this.profile,
    required this.career,
    required this.highlights,
    required this.favorite,
    required this.profile_pic,
  });
  
  @override
  List<Object?> get props => [
    doctor_id,
    name,
    experience,
    focus,
    special,
    starts,
    messages,
    date,
    profile,
    career,
    highlights,
    favorite,
    profile_pic
  ];
}
