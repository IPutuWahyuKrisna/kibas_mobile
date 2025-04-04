import 'package:get_it/get_it.dart';
import 'package:kibas_mobile/src/features/employee/features/complaint/domain/repositories/complaint_repository.dart';
import '../../features/employee/features/complaint/data/repositories/complaint_repository_impl.dart';
import '../../features/employee/features/complaint/data/datasources/complaint_remote_data_source.dart';
import '../../features/employee/features/complaint/domain/usecases/get_all_complaints_usecase.dart';
import '../../features/employee/features/complaint/domain/usecases/get_complaint_detail_usecase.dart';
import '../../features/employee/features/complaint/presentation/bloc/complaint_bloc.dart';

final complaintInjec = GetIt.instance; // 🟢 Injeksi khusus untuk complaint

Future<void> initComplaintServices() async {
  // 🟢 Data Sources
  complaintInjec.registerLazySingleton<ComplaintRemoteDataSource>(
      () => ComplaintRemoteDataSourceImpl(complaintInjec()));

  // 🟢 Repository
  complaintInjec.registerLazySingleton<ComplaintRepositoryDomain>(
      () => ComplaintRepositoryImpl(complaintInjec()));

  // 🟢 Use Cases
  complaintInjec
      .registerLazySingleton(() => GetAllComplaintsUseCase(complaintInjec()));
  complaintInjec
      .registerLazySingleton(() => GetComplaintDetailUseCase(complaintInjec()));

  // 🟢 Bloc
  complaintInjec.registerFactory(() => ComplaintBloc(
        getAllComplaints: complaintInjec(),
        getComplaintDetail: complaintInjec(),
      ));
}
