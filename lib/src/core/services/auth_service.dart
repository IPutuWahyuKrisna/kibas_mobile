import 'package:get_it/get_it.dart';
import 'package:kibas_mobile/src/features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/login_repository_data.dart';
import '../../features/auth/domain/repositories/login_repository_domain.dart';
import '../../features/auth/domain/usecases/get_dropdown_usecases.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../utils/user_local_storage_service.dart';

final authInjec = GetIt.instance;

void setupAuthServices() {
  // 🟢 Data Sources
  authInjec.registerSingleton<AuthRemoteDataSource>(
    AuthRemoteDataSourceImpl(authInjec()),
  );

  // 🟢 Repositories
  authInjec.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      remoteDataSource: authInjec<AuthRemoteDataSource>(),
      localStorageService: authInjec<UserLocalStorageService>(),
    ),
  );

  // 🟢 Use Cases
  authInjec.registerLazySingleton(
      () => RegisterUseCase(authInjec<AuthRepository>()));
  authInjec.registerLazySingleton(
      () => GetGolonganListUseCase(authInjec<AuthRepository>()));
  authInjec.registerLazySingleton(
      () => GetKecamatanListUseCase(authInjec<AuthRepository>()));
  authInjec.registerLazySingleton(
      () => GetKelurahanListUseCase(authInjec<AuthRepository>()));
  authInjec.registerLazySingleton(
      () => GetAreaListUseCase(authInjec<AuthRepository>()));

  // 🟢 Blocs
  authInjec.registerFactory(() => AuthBloc(
        registerUseCase: authInjec(),
        getGolonganListUseCase: authInjec(),
        getKecamatanListUseCase: authInjec(),
        getKelurahanListUseCase: authInjec(),
        getAreaListUseCase: authInjec(),
        authRepository: authInjec(),
      ));
}
