import 'package:skin_firts/core/storage/data_state.dart';
import 'package:skin_firts/data/models/register_user_model/register_user_model.dart';
import 'package:skin_firts/domain/entity/register_user_entity/register_user_entity.dart';

abstract class RegisterUserRepository {
  Future<DataState<RegisterUserResponseEntity>> registerPatient(
    RegisterUserModel registerUserModel,
  );
}