import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_firts/domain/usecases/get_running_appointment_number_usecase/get_running_appointment_number_usecase.dart';

import '../../../../core/storage/data_state.dart';
import '../../../../data/models/running_appointment_number_model/running_appointment_number_model.dart';
import '../../../../service_locator.dart';
import 'get_running_appointment_number_state.dart';

class GetRunningAppointmentNumberCubit extends Cubit<GetRunningAppointmentNumberState> {
  GetRunningAppointmentNumberCubit() : super(GetRunningAppointmentNumberInitial());

  Future<void> getRunningAppointmentNumber(String doctorId, String date) async {
    emit(GetRunningAppointmentNumberLoading());
    final result = await sl<GetRunningAppointmentNumberUsecase>().call(params: RunningAppointmentNumberParamsModel(doctorId: doctorId, date: date));
    if (result is DataSuccess) {
      emit(GetRunningAppointmentNumberLoaded(result.data!));
    } else {
      emit(GetRunningAppointmentNumberError(result.error!));
    }
  }
}