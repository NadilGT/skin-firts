import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_firts/presentation/pages/appointment/next_appointment_number_cubit/next_appointment_number_state.dart';

import '../../../../core/storage/data_state.dart';
import '../../../../domain/usecases/get_next_appointment_number_usecase/get_next_appointment_number_usecase.dart';
import '../../../../service_locator.dart';

class NextAppointmentNumberCubit extends Cubit<NextAppointmentNumberState>{
  NextAppointmentNumberCubit():super(NextAppointmentNumberInitial());

  Future<void> getNextAppointmentNumber(String doctorId,String date)async{
    emit(NextAppointmentNumberLoading());
    final dataState = await sl<GetNextAppointmentNumberUsecase>().call(params: Params(doctorId: doctorId, date: date));
    if(dataState is DataSuccess){
      emit(NextAppointmentNumberLoaded(dataState.data!));
    }else{
      emit(NextAppointmentNumberError(dataState.error!));
    }
  }
}