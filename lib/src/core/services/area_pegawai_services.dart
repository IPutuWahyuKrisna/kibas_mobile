import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:kibas_mobile/src/features/employee/features/area_employee/domain/repositories/area_pegawai_repository.dart';
import '../../features/employee/features/area_employee/data/datasources/area_pegawai_remote_data_source.dart';
import '../../features/employee/features/area_employee/data/repositories/area_pegawai_repository_impl.dart';
import '../../features/employee/features/area_employee/domain/usecases/get_area_pegawai_usecase.dart';
import '../../features/employee/features/area_employee/presentation/bloc/area_employee_bloc.dart';

final areaInjec = GetIt.instance; // 🟢 Injeksi khusus untuk Area Pegawai

Future<void> initAreaPegawaiServices() async {
  // 🟢 Data Sources
  areaInjec.registerLazySingleton<AreaPegawaiRemoteDataSource>(
      () => AreaPegawaiRemoteDataSourceImpl(areaInjec<Dio>()));

  // 🟢 Repository
  areaInjec.registerLazySingleton<AreaPegawaiRepositoryDomain>(() =>
      AreaPegawaiRepositoryImpl(
          remoteDataSource: areaInjec<AreaPegawaiRemoteDataSource>()));

  // 🟢 Use Cases
  areaInjec.registerLazySingleton(
      () => GetAreaPegawaiUseCase(areaInjec<AreaPegawaiRepositoryDomain>()));

  // 🟢 Bloc
  areaInjec.registerFactory(
      () => AreaEmployeeBloc(areaInjec<GetAreaPegawaiUseCase>()));
}
