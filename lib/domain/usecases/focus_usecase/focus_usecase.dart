import 'package:skin_firts/core/storage/data_state.dart';
import 'package:skin_firts/domain/repositories/focus_repository/focus_repository.dart';
import 'package:skin_firts/domain/usecases/usecase/usecase.dart';
import 'package:skin_firts/service_locator.dart';

class FocusUsecase implements UseCase<DataState, Null> {
  @override
  Future<DataState> call({Null params}) {
    return sl<FocusRepository>().getAllFocus();
  }
}
