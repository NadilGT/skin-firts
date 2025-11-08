import 'package:equatable/equatable.dart';

class DoctorInfoEntity extends Equatable{
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
  final String profilePic;

  const DoctorInfoEntity({
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
    required this.profilePic,
  });
  
  @override
  List<Object?> get props => [
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
    favorite
  ];
}
