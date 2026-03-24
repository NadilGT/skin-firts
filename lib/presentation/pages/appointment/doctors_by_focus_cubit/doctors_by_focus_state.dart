import 'package:skin_firts/data/models/doctor_info_model/doctor_info_model.dart';

abstract class DoctorsByFocusState {}

class DoctorsByFocusInitial extends DoctorsByFocusState {}

class DoctorsByFocusLoading extends DoctorsByFocusState {}

class DoctorsByFocusLoaded extends DoctorsByFocusState {
  final List<DoctorInfoModel> doctors;
  DoctorsByFocusLoaded({required this.doctors});
}

class DoctorsByFocusFailed extends DoctorsByFocusState {
  final String error;
  DoctorsByFocusFailed({required this.error});
}