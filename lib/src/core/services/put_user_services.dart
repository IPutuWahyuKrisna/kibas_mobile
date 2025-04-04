import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import '../../features/users/features/dashboard_user/data/datasources/put_remote_datasource.dart';
import '../../features/users/features/dashboard_user/data/repositories/put_repository.dart';
import '../../features/users/features/dashboard_user/domain/repositories/put_user_repository_domain.dart';
import '../../features/users/features/dashboard_user/domain/usecases/get_dropdown.dart';
import '../../features/users/features/dashboard_user/domain/usecases/put_user_usecase.dart';
import '../../features/users/features/dashboard_user/presentation/bloc/dashboard_user_bloc.dart';
import '../utils/user_local_storage_service.dart';

final putUserInjec = GetIt.instance; // GetIt Singleton

Future<void> initPutUsersProfile() async {
  // 🛠 Register Data Sources
  putUserInjec.registerLazySingleton<PutRemoteDataSource>(
      () => PutRemoteDataSourceImpl(putUserInjec<Dio>()));

  // 🛠 Register Repositories
  putUserInjec.registerLazySingleton<PutUserRepositoryDomain>(
      () => PutUserRepositoryImpl(
            remoteDataSource: putUserInjec<PutRemoteDataSource>(),
            localStorageService: putUserInjec<UserLocalStorageService>(),
          ));

  // 🛠 Register Use Cases
  putUserInjec.registerLazySingleton(
      () => PutUserUseCase(putUserInjec<PutUserRepositoryDomain>()));
  putUserInjec.registerLazySingleton(
      () => GetGolonganListUseCase(putUserInjec<PutUserRepositoryDomain>()));
  putUserInjec.registerLazySingleton(
      () => GetKecamatanListUseCase(putUserInjec<PutUserRepositoryDomain>()));
  putUserInjec.registerLazySingleton(
      () => GetKelurahanListUseCase(putUserInjec<PutUserRepositoryDomain>()));
  putUserInjec.registerLazySingleton(
      () => GetAreaListUseCase(putUserInjec<PutUserRepositoryDomain>()));

  // 🛠 Register Blocs
  putUserInjec.registerFactory(() => DashboardUserBloc(
        putRepository: putUserInjec(),
        getGolonganListUseCase: putUserInjec(),
        getKecamatanListUseCase: putUserInjec(),
        getKelurahanListUseCase: putUserInjec(),
        getAreaListUseCase: putUserInjec(),
      ));
}
