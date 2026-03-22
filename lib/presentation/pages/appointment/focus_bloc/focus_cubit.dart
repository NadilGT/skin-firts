import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_firts/presentation/pages/appointment/focus_bloc/focus_state.dart';

import '../../../../core/storage/data_state.dart';
import '../../../../domain/usecases/focus_usecase/focus_usecase.dart';
import '../../../../service_locator.dart';

class FocusCubit extends Cubit<FocusState>{
  FocusCubit():super(FocusLoading());

  Future<void> getAllFocus()async{
    emit(FocusLoading());
    final dataState = await sl<FocusUsecase>().call();
    if(dataState is DataSuccess){
      emit(FocusLoaded(focusEntity: dataState.data!));
    }else{
      emit(FocusFailed(error: dataState.error!));
    }
  }
}