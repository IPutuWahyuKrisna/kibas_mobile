import 'package:get_it/get_it.dart';

import '../../features/employee/features/complaint/data/datasources/complaint_remote_data_source.dart';
import '../../features/employee/features/complaint/data/repositories/complaint_repository_impl.dart';
import '../../features/employee/features/complaint/domain/repositories/complaint_repository.dart';
import '../../features/employee/features/complaint/domain/usecases/get_all_complaints_usecase.dart';
import '../../features/employee/features/complaint/domain/usecases/post_complaint_employee_usecase.dart';
import '../../features/employee/features/complaint/presentation/bloc/complaint_bloc.dart';

final complaintInjec = GetIt.instance;

/// 🟢 Injeksi layanan untuk fitur ComplaintEmployee
Future<void> initComplaintEmployeeServices() async {
  // 🟢 Data Source
  complaintInjec.registerLazySingleton<ComplaintRemoteDataSource>(
    () => ComplaintRemoteDataSourceImpl(
      dio: complaintInjec(),
      compressionService:
          complaintInjec(), // pastikan dio sudah di-inject sebelumnya // contoh: GetStorageService
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
    () => FetchComplaintEmployeeUseCase(complaintInjec()),
  );

  complaintInjec.registerLazySingleton(
    () => PostComplaintEmployeeUseCase(complaintInjec()),
  );

  // 🟢 Bloc
  complaintInjec.registerFactory(
    () => ComplaintBloc(
      fetchComplaints: complaintInjec(),
      postComplaint: complaintInjec(),
    ),
  );
}
