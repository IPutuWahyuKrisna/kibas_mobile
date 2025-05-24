import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:kibas_mobile/src/features/users/features/rekening/domain/usecases/get_tagihan_usecase.dart';

import '../../features/users/features/rekening/data/datasources/rekening_remote_data_source.dart';
import '../../features/users/features/rekening/data/repositories/rekening_repository_impl.dart';
import '../../features/users/features/rekening/domain/repositories/rekening_repository.dart';
import '../../features/users/features/rekening/domain/usecases/get_dropdownd_rekening.dart';
import '../../features/users/features/rekening/domain/usecases/get_rekening_detail_usecase.dart';
import '../../features/users/features/rekening/domain/usecases/get_rekening_usecase.dart';
import '../../features/users/features/rekening/domain/usecases/post_rekening_usecase.dart';
import '../../features/users/features/rekening/domain/usecases/put_rekening_usecase.dart';
import '../../features/users/features/rekening/presentation/bloc/rekening_bloc.dart';

final rekeningInjec = GetIt.instance;

void initRekeningModule() {
  // 🔹 Register Remote Data Source
  rekeningInjec.registerLazySingleton<RekeningRemoteDataSource>(
    () => RekeningRemoteDataSourceImpl(dio: rekeningInjec<Dio>()),
  );

  // 🔹 Register Repository
  rekeningInjec.registerLazySingleton<RekeningRepository>(
    () => RekeningRepositoryImpl(
        remoteDataSource: rekeningInjec<RekeningRemoteDataSource>()),
  );

  // 🔹 Register Use Case
  rekeningInjec.registerLazySingleton<GetRekeningUseCase>(
    () => GetRekeningUseCase(rekeningInjec<RekeningRepository>()),
  );
  rekeningInjec.registerLazySingleton<GetRekeningDetailUseCase>(
    () => GetRekeningDetailUseCase(rekeningInjec<RekeningRepository>()),
  );
  rekeningInjec.registerLazySingleton(
      () => GetGolonganListUseCase(rekeningInjec<RekeningRepository>()));
  rekeningInjec.registerLazySingleton(
      () => GetKecamatanListUseCase(rekeningInjec<RekeningRepository>()));
  rekeningInjec.registerLazySingleton(
      () => GetKelurahanListUseCase(rekeningInjec<RekeningRepository>()));
  rekeningInjec.registerLazySingleton(
      () => GetAreaListUseCase(rekeningInjec<RekeningRepository>()));
  rekeningInjec.registerLazySingleton(
      () => GetRayonListUseCase(rekeningInjec<RekeningRepository>()));
  rekeningInjec.registerLazySingleton(
      () => PostRekeningUseCase(rekeningInjec<RekeningRepository>()));
  rekeningInjec.registerLazySingleton(
      () => PutRekeningUseCase(rekeningInjec<RekeningRepository>()));
  rekeningInjec.registerLazySingleton(
      () => GetTagihanUseCase(rekeningInjec<RekeningRepository>()));

  // 🔹 Register BLoC
  rekeningInjec.registerFactory<RekeningBloc>(
    () => RekeningBloc(
      getRekeningUseCase: rekeningInjec<GetRekeningUseCase>(),
      getRekeningDetailUseCase: rekeningInjec<GetRekeningDetailUseCase>(),
      getGolonganListUseCase: rekeningInjec(),
      getKecamatanListUseCase: rekeningInjec(),
      getKelurahanListUseCase: rekeningInjec(),
      getRayonListUseCase: rekeningInjec(),
      getAreaListUseCase: rekeningInjec(),
      postRekeningUseCase: rekeningInjec(),
      putRekeningUseCase: rekeningInjec(),
      getTagihanUseCase: rekeningInjec(),
    ),
  );
}
