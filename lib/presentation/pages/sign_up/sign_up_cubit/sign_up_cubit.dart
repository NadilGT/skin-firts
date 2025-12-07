import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_firts/core/storage/data_state.dart';
import 'package:skin_firts/data/models/sign_up_user_model/sign_up_user_model.dart';
import 'package:skin_firts/domain/usecases/sign_up_usecase/sign_up_use_case.dart';
import 'package:skin_firts/presentation/pages/sign_up/sign_up_cubit/sign_up_state.dart';
import 'package:skin_firts/service_locator.dart';

class SignUpCubit extends Cubit<SignUpState>{

  SignUpCubit(): super(SignUpInitial());

  Future<void> signUp(SignUpUserModel signUpUserModel)async{
    emit(SignUpLoading());

    final result = await sl<SignUpUseCase>().call(
      params: signUpUserModel
    );

    if (result is DataSuccess){
      emit(SignUpSuccess(data: result));
    } else if (result is DataFailed){
      emit(SignUpFailure(result.error ?? "Sign Up Failed"));
    }
  }

}
