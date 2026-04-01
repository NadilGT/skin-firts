import '../../../../data/models/doctor_schedule_model/doctor_schedule_model.dart';

abstract class DoctorScheduleState {}

class DoctorScheduleLoading extends DoctorScheduleState{}

class DoctorScheduleLoaded extends DoctorScheduleState{
  final DoctorScheduleResponseModel doctorScheduleResponseModel;
  DoctorScheduleLoaded({required this.doctorScheduleResponseModel});
}

class DoctorScheduleFailed extends DoctorScheduleState{
  final String error;
  DoctorScheduleFailed({required this.error});
}