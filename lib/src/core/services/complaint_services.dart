import 'package:get_it/get_it.dart';

import '../../features/employee/features/complaint/data/datasources/complaint_remote_data_source.dart';
import '../../features/employee/features/complaint/data/repositories/complaint_repository_impl.dart';
import '../../features/employee/features/complaint/domain/repositories/complaint_repository.dart';
import '../../features/employee/features/complaint/domain/usecases/get_all_complaints_usecase.dart';
import '../../features/employee/features/complaint/presentation/bloc/complaint_bloc.dart';

final complaintInjec =
    GetIt.instance; // 🟢 Injeksi khusus untuk ComplaintEmployee

Future<void> initComplaintEmployeeServices() async {
  // 🟢 Data Sources
  complaintInjec.registerLazySingleton<ComplaintEmployeeRemoteDataSource>(
    () => ComplaintEmployeeRemoteDataSourceImpl(
      dio: complaintInjec(),
      storage: complaintInjec(),
    ),
  );

  // 🟢 Repository
  complaintInjec.registerLazySingleton<ComplaintEmployeeRepository>(
    () => ComplaintEmployeeRepositoryImpl(
      remoteDataSource: complaintInjec(),
    ),
  );

  // 🟢 Use Cases
  complaintInjec.registerLazySingleton(
    () => GetAllComplaintEmployeeUseCase(complaintInjec()),
  );

  // complaintInjec.registerLazySingleton(
  //   () => GetComplaintEmployeeDetailUseCase(complaintInjec()),
  // );

  // 🟢 Bloc
  complaintInjec.registerFactory(
    () => ComplaintEmployeeBloc(
      getAllComplaintEmployeeUseCase: complaintInjec(),
    ),
  );
}
