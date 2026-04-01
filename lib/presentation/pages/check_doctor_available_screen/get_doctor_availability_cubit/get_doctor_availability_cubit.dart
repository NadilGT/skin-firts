import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_firts/domain/usecases/get_doctor_availability_usecase/get_doctor_availability_usecase.dart';

import '../../../../core/storage/data_state.dart';
import '../../../../domain/entity/doctor_availability_entity/doctor_availability_entity.dart';
import 'get_doctor_availability_state.dart';

class GetDoctorAvailabilityCubit extends Cubit<GetDoctorAvailabilityState> {
  GetDoctorAvailabilityCubit() : super(GetDoctorAvailabilityInitial());
  final GetDoctorAvailabilityUsecase _getDoctorAvailabilityUsecase = GetDoctorAvailabilityUsecase();
  Future<void> getDoctorAvailability(DoctorAvailabilityParams params) async {
    emit(GetDoctorAvailabilityLoading());
    final dataState = await _getDoctorAvailabilityUsecase(params: params);
    if (dataState is DataSuccess) {
      emit(GetDoctorAvailabilityLoaded(doctorAvailabilityModel: dataState.data));
    } else {
      emit(GetDoctorAvailabilityError(error: dataState.error ?? "Something went wrong"));
    }
  }
}