import 'package:skin_firts/domain/entity/doctor_info_entity/doctor_info_entity.dart';

abstract class DoctorInfoState {}

class DoctorInfoLoading extends DoctorInfoState{}

class DoctorInfoLoaded extends DoctorInfoState{
  final DoctorInfoEntity doctorInfoEntity;
  DoctorInfoLoaded({required this.doctorInfoEntity});
}

class DoctorInfoFailed extends DoctorInfoState{
  final String error;
  DoctorInfoFailed({required this.error});
}