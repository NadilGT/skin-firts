import 'package:skin_firts/data/models/doctor_availability_model/doctor_availability_model.dart';

abstract class GetDoctorAvailabilityState {}

class GetDoctorAvailabilityInitial extends GetDoctorAvailabilityState {}

class GetDoctorAvailabilityLoading extends GetDoctorAvailabilityState {}

class GetDoctorAvailabilityLoaded extends GetDoctorAvailabilityState {
  final DoctorAvailabilityModel doctorAvailabilityModel;
  GetDoctorAvailabilityLoaded({required this.doctorAvailabilityModel});
}

class GetDoctorAvailabilityError extends GetDoctorAvailabilityState {
  final String error;
  GetDoctorAvailabilityError({required this.error});
}