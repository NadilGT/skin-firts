abstract class SignInState {}

class SignInInitial extends SignInState{}

class SignInLoading extends SignInState {}

class SignInSuccess extends SignInState{
  final dynamic data;
  SignInSuccess({ this.data});
}

class SignInFailure extends SignInState {
  final String error;
  SignInFailure(this.error);
}