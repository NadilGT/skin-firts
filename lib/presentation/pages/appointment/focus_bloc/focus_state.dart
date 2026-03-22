import '../../../../domain/entity/focus_entity/focus_entity.dart';

abstract class FocusState {}

class FocusLoading extends FocusState {}

class FocusLoaded extends FocusState {
  final List<FocusEntity> focusEntity;
  FocusLoaded({required this.focusEntity});
}

class FocusFailed extends FocusState {
  final String error;
  FocusFailed({required this.error});
}