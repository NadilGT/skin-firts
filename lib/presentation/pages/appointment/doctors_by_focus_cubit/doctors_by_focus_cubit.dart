import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_firts/presentation/pages/appointment/doctors_by_focus_cubit/doctors_by_focus_state.dart';

import '../../../../core/storage/data_state.dart';
import '../../../../domain/usecases/get_all_doctors_by_focus_usecase/get_all_doctors_by_focus_usecase.dart';
import '../../../../service_locator.dart';

class DoctorsByFocusCubit extends Cubit<DoctorsByFocusState>{
  DoctorsByFocusCubit():super(DoctorsByFocusInitial());

  Future<void> getAllDoctorsByFocus(String focus)async{
    emit(DoctorsByFocusLoading());
    final dataState = await sl<GetAllDoctorsByFocusUseCase>().call(params: focus);
    if(dataState is DataSuccess){
      emit(DoctorsByFocusLoaded(doctors: dataState.data ?? []));
    }else{
      emit(DoctorsByFocusFailed(error: dataState.error ?? "Unknown error"));
    } 
  }
}