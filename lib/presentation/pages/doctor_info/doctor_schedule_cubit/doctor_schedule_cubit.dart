import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_firts/core/storage/data_state.dart';
import 'package:skin_firts/domain/usecases/get_doctor_schedule_usecase/get_doctor_schedule_usecase.dart';
import 'package:skin_firts/presentation/pages/doctor_info/doctor_schedule_cubit/doctor_schedule_state.dart';
import 'package:skin_firts/service_locator.dart';

class DoctorScheduleCubit extends Cubit<DoctorScheduleState>{
  DoctorScheduleCubit() : super(DoctorScheduleLoading());

  Future<void> getDoctorSchedule(String doctorId) async{
    emit(DoctorScheduleLoading());
    final dataState = await sl<GetDoctorScheduleUsecase>().call(params: doctorId);
    if(dataState is DataSuccess){
      emit(DoctorScheduleLoaded(doctorScheduleResponseModel: dataState.data));
    } else {
      emit(DoctorScheduleFailed(error: dataState.error ?? "Something went wrong"));
    }
  }
}