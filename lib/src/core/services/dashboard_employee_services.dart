import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../../core/utils/user_local_storage_service.dart';
import '../../features/employee/features/dashbord_employee/data/datasources/dashboard_remote_datasource.dart';
import '../../features/employee/features/dashbord_employee/data/repositories/dashboard_repository_impl.dart';
import '../../features/employee/features/dashbord_employee/domain/repositories/dashboard_repository_domain.dart';
import '../../features/employee/features/dashbord_employee/domain/usecases/get_all_announcement_usecase.dart';
import '../../features/employee/features/dashbord_employee/domain/usecases/log_out_usecase.dart';
import '../../features/employee/features/dashbord_employee/presentation/bloc/dashbord_employee_bloc.dart';

final dashboardEmployeeInjec = GetIt.instance;

void setupDashboardServices() {
  // 🟢 Data Source
  dashboardEmployeeInjec.registerSingleton<DashboardRemoteDataSource>(
    DashboardRemoteDataSourceImpl(dashboardEmployeeInjec<Dio>()),
  );

  // 🟢 Repository
  dashboardEmployeeInjec.registerSingleton<DashboardRepositoryDomain>(
    DashboardRepositoryImpl(
      remoteDataSource: dashboardEmployeeInjec<DashboardRemoteDataSource>(),
      localStorageService: dashboardEmployeeInjec<UserLocalStorageService>(),
    ),
  );

  // 🟢 Use Cases
  dashboardEmployeeInjec.registerFactory<GetAllAnnouncementsUseCase>(
    () => GetAllAnnouncementsUseCase(
        dashboardEmployeeInjec<DashboardRepositoryDomain>()),
  );

  dashboardEmployeeInjec.registerFactory<LogoutUseCase>(
    () => LogoutUseCase(dashboardEmployeeInjec<DashboardRepositoryDomain>()),
  );

  // 🟢 Bloc
  dashboardEmployeeInjec.registerFactory<DashbordEmployeeBloc>(
    () => DashbordEmployeeBloc(
      getAllAnnouncementsUseCase:
          dashboardEmployeeInjec<GetAllAnnouncementsUseCase>(),
      logoutUseCase: dashboardEmployeeInjec<LogoutUseCase>(),
    ),
  );
}
