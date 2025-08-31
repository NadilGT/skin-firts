import 'package:get_it/get_it.dart';
import 'package:skin_firts/data/repository_impl/auth/auth_firebase_service_impl.dart';
import 'package:skin_firts/domain/repositories/auth/auth_firebase_service.dart';
import 'package:skin_firts/domain/usecases/login_usecase/login_use_case.dart';

final sl = GetIt.instance;

Future<void> initilizeDependencies()async{

  sl.registerSingleton<AuthFirebaseService>(
    AuthFirebaseServiceImpl()
  );

  sl.registerSingleton<LoginUseCase>(
    LoginUseCase()
  );
}