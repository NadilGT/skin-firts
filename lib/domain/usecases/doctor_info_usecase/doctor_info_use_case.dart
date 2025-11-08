import 'package:skin_firts/core/storage/data_state.dart';
import 'package:skin_firts/domain/repositories/doctor_info_repository/doctor_info_repository.dart';
import 'package:skin_firts/domain/usecases/usecase/usecase.dart';
import 'package:skin_firts/service_locator.dart';

class DoctorInfoUseCase implements UseCase<DataState, String>{
  @override
  Future<DataState> call({String? params}) {
    return sl<DoctorInfoRepository>().getDoctorInfo(params!);
  }

}