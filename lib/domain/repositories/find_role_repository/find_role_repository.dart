import 'package:skin_firts/core/storage/data_state.dart';
import 'package:skin_firts/data/models/find_role_model/find_role_model.dart';

abstract class FindRoleRepository {
  Future<DataState<FindRoleResponseModel>> findRole(String firebaseUid);
}