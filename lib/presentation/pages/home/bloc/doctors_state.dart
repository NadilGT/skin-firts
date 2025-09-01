import 'package:skin_firts/domain/entity/doctor_entity/doctor_entity.dart';

abstract class DoctorsState {}

class DoctorsLoading extends DoctorsState{}

class DoctorsLoaded extends DoctorsState{
  final List<DoctorEntity> doctors;
  DoctorsLoaded({required this.doctors});
}

class DoctorsLoadFailure extends DoctorsState{
  final String error;
  DoctorsLoadFailure({required this.error});
}