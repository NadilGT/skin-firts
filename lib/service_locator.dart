import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:skin_firts/data/repository_impl/auth/auth_firebase_service_impl.dart';
import 'package:skin_firts/data/repository_impl/doctors_repository_impl/doctors_repository_impl.dart';
import 'package:skin_firts/domain/repositories/auth/auth_firebase_service.dart';
import 'package:skin_firts/domain/repositories/doctor_repository/doctor_repository.dart';
import 'package:skin_firts/domain/service/api/api_service.dart';
import 'package:skin_firts/domain/usecases/doctors_usecase/doctors_use_case.dart';
import 'package:skin_firts/domain/usecases/login_usecase/login_use_case.dart';

final sl = GetIt.instance;

Future<void> initilizeDependencies()async{
  // Dio setup
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      responseType: ResponseType.json,
    ),
  );

  sl.registerSingleton<ApiService>(ApiService(dio));

  sl.registerSingleton<AuthFirebaseService>(
    AuthFirebaseServiceImpl()
  );

  sl.registerSingleton<LoginUseCase>(
    LoginUseCase()
  );

  sl.registerSingleton<DoctorRepository>(
    DoctorsRepositoryImpl()
  );

  sl.registerSingleton<DoctorsUseCase>(
    DoctorsUseCase()
  );
}