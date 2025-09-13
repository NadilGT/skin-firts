import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_firts/domain/usecases/doctor_info_usecase/doctor_info_use_case.dart';
import 'package:skin_firts/presentation/pages/doctor_info/bloc/doctor_info_state.dart';

import '../../../../core/storage/data_state.dart';
import '../../../../service_locator.dart';

class DoctorInfoCubit extends Cubit<DoctorInfoState>{
  DoctorInfoCubit() : super(DoctorInfoLoading());

  Future<void> getDoctorInfo(String name)async{
    emit(DoctorInfoLoading());

    var result = await sl<DoctorInfoUseCase>().call(
      params: name
    );
    print("doc info cubit wada");
    if (result is DataSuccess){
      print("doc success");
      emit(DoctorInfoLoaded(doctorInfoEntity: result.data));
    } else if (result is DataFailed){
      print("doc failed");
      emit(DoctorInfoFailed(error: result.error ?? "Doctor info loading error"));
    }
  }
}