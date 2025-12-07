import 'package:skin_firts/core/storage/data_state.dart';

abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {
  final DataState data;
  SignUpSuccess({required this.data});
}

class SignUpFailure extends SignUpState {
  final String error;
  SignUpFailure(this.error);
}
