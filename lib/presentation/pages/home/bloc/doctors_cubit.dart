import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_firts/core/storage/data_state.dart';
import 'package:skin_firts/domain/usecases/doctors_usecase/doctors_use_case.dart';
import 'package:skin_firts/presentation/pages/home/bloc/doctors_state.dart';
import 'package:skin_firts/service_locator.dart';

class DoctorsCubit extends Cubit<DoctorsState>{
  DoctorsCubit() : super(DoctorsLoading());

  Future<void> getDoctors() async {
    emit(DoctorsLoading());

    var result = await sl<DoctorsUseCase>().call();
    print("doc cubit wada");
    if (result is DataSuccess){
      print("doc success");
      emit(DoctorsLoaded(doctors: result.data));
    } else if (result is DataFailed){
      print("doc failed");
      emit(DoctorsLoadFailure(error: result.error ?? "Doctors loading error"));
    }
  }
}