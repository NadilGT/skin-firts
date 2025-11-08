import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:skin_firts/core/network/token_interceptor.dart';
import 'package:skin_firts/data/repository_impl/auth/auth_firebase_service_impl.dart';
import 'package:skin_firts/data/repository_impl/doctors_repository_impl/doctors_repository_impl.dart';
import 'package:skin_firts/data/repository_impl/toggle_favorite_repository_impl/toggle_favorite_repository_impl.dart';
import 'package:skin_firts/domain/repositories/auth/auth_firebase_service.dart';
import 'package:skin_firts/domain/repositories/doctor_repository/doctor_repository.dart';
import 'package:skin_firts/domain/repositories/toggle_favorite_repository/toggle_favorite_repository.dart';
import 'package:skin_firts/domain/service/api/api_service.dart';
import 'package:skin_firts/domain/usecases/doctor_info_usecase/doctor_info_use_case.dart';
import 'package:skin_firts/domain/usecases/doctors_usecase/doctors_use_case.dart';
import 'package:skin_firts/domain/usecases/login_usecase/login_use_case.dart';
import 'package:skin_firts/domain/usecases/toggle_favorite_usecase/toggle_favorite_usecase.dart';

import 'core/storage/shared_pref_manager.dart';
import 'data/repository_impl/doctor_info_repository_impl/doctor_info_repository_impl.dart';
import 'domain/repositories/doctor_info_repository/doctor_info_repository.dart';

final sl = GetIt.instance;

Future<void> initilizeDependencies()async{

  final sharedPrefManager = SharedPrefManager();
  sl.registerSingleton<SharedPrefManager>(sharedPrefManager);
  await sharedPrefManager.getToken();

  // Dio setup
  final dio = Dio();
  dio.interceptors.add(FirebaseAuthInterceptor(
    sharedPrefManager: sharedPrefManager,
  ));
  dio.interceptors.add(LogInterceptor(
    request: true,
    requestHeader: true,
    requestBody: true,
    responseHeader: true,
    responseBody: true,
    error: true,
    logPrint: (object) => print(object),
  ));

  sl.registerSingleton<Dio>(dio);

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

  sl.registerSingleton<DoctorInfoUseCase>(
    DoctorInfoUseCase()
  );

  sl.registerSingleton<DoctorInfoRepository>(
    DoctorInfoRepositoryImpl()
  );

  sl.registerSingleton<ToggleFavoriteRepository>(
    ToggleFavoriteRepositoryImpl()
  );

  sl.registerSingleton<ToggleFavoriteUsecase>(
    ToggleFavoriteUsecase()
  );
}