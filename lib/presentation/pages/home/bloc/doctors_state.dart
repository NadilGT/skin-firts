import '../../../../data/models/doctor_info_model/doctor_info_model.dart';

abstract class DoctorsState {}

class DoctorsLoading extends DoctorsState{}

class DoctorsLoaded extends DoctorsState{
  final List<DoctorInfoModel> doctors;
  DoctorsLoaded({required this.doctors});
}

class DoctorsLoadFailure extends DoctorsState{
  final String error;
  DoctorsLoadFailure({required this.error});
}