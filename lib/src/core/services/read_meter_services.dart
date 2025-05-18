import 'package:get_it/get_it.dart';
import '../../features/users/features/read meter/data/repositories/read_meter_repository_impl.dart';
import '../../features/users/features/read meter/data/datasources/read_meter_remote_data_source.dart';
import '../../features/users/features/read meter/domain/repositories/read_meter_repository.dart';
import '../../features/users/features/read meter/domain/usecases/fetch_read_meter_usecase.dart';
import '../../features/users/features/read meter/domain/usecases/post_meter_usecase.dart';
import '../../features/users/features/read meter/presentation/bloc/read_meter_bloc.dart';
import 'image_compression_service.dart';

final meterInjec = GetIt.instance;

Future<void> initMeterServices() async {
  // 🟢 Utils
  meterInjec.registerLazySingleton(() => ImageProcessor());

  // 🟢 Data Sources
  meterInjec.registerLazySingleton<ReadMeterRemoteDataSource>(() =>
      ReadMeterRemoteDataSourceImpl(
          meterInjec(), meterInjec<ImageProcessor>()));

  // 🟢 Repository
  meterInjec.registerLazySingleton<MeterRepositoryDomain>(
      () => ReadMeterRepositoryImpl(meterInjec()));

  // 🟢 Use Cases
  // Read Meter Use Case
  meterInjec.registerLazySingleton(() => GetListMeterUseCase(meterInjec()));

  // Postmeter Use Case
  meterInjec.registerLazySingleton(() => SubmitPostmeterUseCase(meterInjec()));

  // 🟢 Bloc
  meterInjec.registerFactory(() => ReadMeterBloc(
        getListMeterUseCase: meterInjec(),
        postMeterUseCase: meterInjec(),
      ));
}
