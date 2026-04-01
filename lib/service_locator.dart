import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:skin_firts/core/network/token_interceptor.dart';
import 'package:skin_firts/data/repository_impl/auth/auth_firebase_service_impl.dart';
import 'package:skin_firts/data/repository_impl/doctors_repository_impl/doctors_repository_impl.dart';
import 'package:skin_firts/data/repository_impl/find_role_repository_impl/find_role_repository_impl.dart';
import 'package:skin_firts/data/repository_impl/register_user_repository_impl/register_user_repository_impl.dart';
import 'package:skin_firts/data/repository_impl/toggle_favorite_repository_impl/toggle_favorite_repository_impl.dart';
import 'package:skin_firts/domain/repositories/auth/auth_firebase_service.dart';
import 'package:skin_firts/domain/repositories/doctor_repository/doctor_repository.dart';
import 'package:skin_firts/domain/repositories/find_role_repository/find_role_repository.dart';
import 'package:skin_firts/domain/repositories/register_user_repository/register_user_repository.dart';
import 'package:skin_firts/domain/repositories/toggle_favorite_repository/toggle_favorite_repository.dart';
import 'package:skin_firts/domain/service/api/api_service.dart';
import 'package:skin_firts/domain/usecases/appointment_usecase/get_all_appointments_usecase.dart';
import 'package:skin_firts/domain/usecases/doctor_info_usecase/doctor_info_use_case.dart';
import 'package:skin_firts/domain/usecases/doctors_usecase/doctors_use_case.dart';
import 'package:skin_firts/domain/usecases/get_doctor_schedule_usecase/get_doctor_schedule_usecase.dart' show GetDoctorScheduleUsecase;
import 'package:skin_firts/domain/usecases/login_usecase/login_use_case.dart';
import 'package:skin_firts/domain/usecases/sign_up_usecase/sign_up_use_case.dart';
import 'package:skin_firts/domain/usecases/toggle_favorite_usecase/toggle_favorite_usecase.dart';
import 'package:skin_firts/common/bloc/theme_cubit.dart';
import 'package:skin_firts/presentation/pages/calender/bloc1/appointments_cubit.dart';
import 'package:skin_firts/presentation/pages/doctor_info/doctor_schedule_cubit/doctor_schedule_cubit.dart' show DoctorScheduleCubit;

import 'core/storage/shared_pref_manager.dart';
import 'data/repository_impl/appointment_repository_impl/appointment_repository_impl.dart';
import 'data/repository_impl/doctor_availability_repository_impl/doctor_availability_repository_impl.dart';
import 'data/repository_impl/doctor_info_repository_impl/doctor_info_repository_impl.dart';
import 'data/repository_impl/doctor_schedule_repository_impl/doctor_schedule_repository_impl.dart';
import 'data/repository_impl/focus_repository_impl/focus_repository_impl.dart';
import 'domain/repositories/appointment_repository/appointment_repository.dart';
import 'domain/repositories/doctor_availability_repository/doctor_availability_repository.dart';
import 'domain/repositories/doctor_info_repository/doctor_info_repository.dart';
import 'domain/repositories/doctor_schedule_repository/doctor_schedule_repository.dart';
import 'domain/repositories/focus_repository/focus_repository.dart';
import 'domain/usecases/appointment_usecase/appointment_usecase.dart';
import 'domain/usecases/focus_usecase/focus_usecase.dart';
import 'domain/usecases/get_all_doctors_by_focus_usecase/get_all_doctors_by_focus_usecase.dart';
import 'domain/usecases/get_doctor_availability_usecase/get_doctor_availability_usecase.dart';
import 'domain/usecases/get_next_appointment_number_usecase/get_next_appointment_number_usecase.dart';
import 'domain/usecases/get_running_appointment_number_usecase/get_running_appointment_number_usecase.dart';
import 'presentation/pages/appointment/next_appointment_number_cubit/next_appointment_number_cubit.dart';
import 'presentation/pages/calender/bloc/appoinment_cubit.dart';
import 'presentation/pages/check_doctor_available_screen/get_doctor_availability_cubit/get_doctor_availability_cubit.dart';
import 'presentation/pages/get_running_appointment_number/cubit/get_running_appointment_number_cubit.dart';
import 'presentation/providers/notification_provider.dart';
import 'data/datasources/fcm_datasource.dart';
import 'data/repository_impl/notification_repository_impl/notification_repository_impl.dart';
import 'domain/repositories/notification_repository/notification_repository.dart';
import 'data/repository_impl/save_fcm_token_repository_impl/save_fcm_token_repository_impl.dart';
import 'domain/repositories/save_fcm_token_repositoy/save_fcm_token_repositoy.dart';
import 'domain/usecases/save_fcm_token_usecase/save_fcm_token_usecase.dart';

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

  sl.registerSingleton<RegisterUserRepository>(
    RegisterUserRepositoryImpl()
  );

  sl.registerSingleton<FindRoleRepository>(
    FindRoleRepositoryImpl()
  );

  sl.registerSingleton<LoginUseCase>(
    LoginUseCase()
  );

  sl.registerSingleton<SignUpUseCase>(
    SignUpUseCase()
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

  sl.registerSingleton<AppointmentRepository>(
    AppointmentRepositoryImpl(),
  );

  sl.registerSingleton<AppointmentUsecase>(
    AppointmentUsecase(),
  );

    sl.registerSingleton<GetAllAppointmentsUsecase>(
    GetAllAppointmentsUsecase(),
  );

  sl.registerSingleton<ThemeCubit>(
    ThemeCubit(),
  );

  sl.registerSingleton<FocusRepository>(
    FocusRepositoryImpl(),
  );

  sl.registerSingleton<FocusUsecase>(
    FocusUsecase(),
  );

  sl.registerSingleton<GetAllDoctorsByFocusUseCase>(
    GetAllDoctorsByFocusUseCase(),
  );

  sl.registerSingleton<GetNextAppointmentNumberUsecase>(
    GetNextAppointmentNumberUsecase(),
  );

  sl.registerSingleton<GetRunningAppointmentNumberUsecase>(
    GetRunningAppointmentNumberUsecase(),
  );

  sl.registerSingleton<GetDoctorScheduleUsecase>(
    GetDoctorScheduleUsecase(),
  );

  sl.registerSingleton<DoctorScheduleRepository>(
    DoctorScheduleRepositoryImpl(),
  );

  sl.registerSingleton<DoctorAvailabilityRepository>(
    DoctorAvailabilityRepositoryImpl(),
  );

  sl.registerSingleton<GetDoctorAvailabilityUsecase>(
    GetDoctorAvailabilityUsecase(),
  );

  sl.registerFactory<AppointmentCubit>(() => AppointmentCubit(appointmentUsecase: AppointmentUsecase()));

  sl.registerFactory<AppointmentCubits>(() => AppointmentCubits(getAllAppointmentsUsecase: GetAllAppointmentsUsecase()));

  sl.registerFactory<NextAppointmentNumberCubit>(
    () => NextAppointmentNumberCubit(),
  );

  sl.registerFactory<GetRunningAppointmentNumberCubit>(
    () => GetRunningAppointmentNumberCubit(),
  );

  sl.registerFactory<DoctorScheduleCubit>(
    () => DoctorScheduleCubit(),
  );

  sl.registerFactory<GetDoctorAvailabilityCubit>(
    () => GetDoctorAvailabilityCubit(),
  );

  sl.registerSingleton<FCMDataSource>(
    FCMDataSource(),
  );

  sl.registerSingleton<NotificationRepository>(
    NotificationRepositoryImpl(sl()),
  );

  sl.registerSingleton<SaveFcmTokenRepository>(
    SaveFcmTokenRepositoryImpl(),
  );

  sl.registerSingleton<SaveFcmTokenUseCase>(
    SaveFcmTokenUseCase(),
  );

  sl.registerSingleton<NotificationProvider>(
    NotificationProvider(sl(), sl()),
  );

}