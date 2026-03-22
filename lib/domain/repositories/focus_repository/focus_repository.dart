import 'package:skin_firts/core/storage/data_state.dart';
import 'package:skin_firts/data/models/focus_model/focus_model.dart';

abstract class FocusRepository {
  Future<DataState<List<FocusModel>>> getAllFocus();
}