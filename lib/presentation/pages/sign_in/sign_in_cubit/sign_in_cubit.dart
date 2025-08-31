import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_firts/core/storage/data_state.dart';
import 'package:skin_firts/data/models/login_user_model/login_user_model.dart';
import 'package:skin_firts/domain/usecases/login_usecase/login_use_case.dart';
import 'package:skin_firts/presentation/pages/sign_in/sign_in_cubit/sign_in_state.dart';
import 'package:skin_firts/service_locator.dart';

class SignInCubit extends Cubit<SignInState>{

  SignInCubit(): super(SignInInitial());

  Future<void> signIn(LoginUserModel loginUserModel)async{
    emit(SignInLoading());

    final result = await sl<LoginUseCase>().call(
      params: loginUserModel
    );

    if (result is DataSuccess){
      emit(SignInSuccess(data: result));
    } else if (result is DataFailed){
      emit(SignInFailure("Sign In Failed"));
    }
  }

}