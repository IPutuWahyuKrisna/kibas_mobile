import 'package:get_it/get_it.dart';
import 'package:kibas_mobile/src/features/users/features/complaint_users/domain/repositories/complaint_users_repository.dart';
import 'package:kibas_mobile/src/features/users/features/complaint_users/domain/usecases/put_complaint_usecase.dart';
import '../../features/users/features/complaint_users/data/datasources/complaint_users_remote_data_source.dart';
import '../../features/users/features/complaint_users/data/repositories/complaint_usres_repository_impl.dart';
import '../../features/users/features/complaint_users/domain/usecases/delete_complaint.dart';
import '../../features/users/features/complaint_users/domain/usecases/get_all_complaints_users_usecase.dart';
import '../../features/users/features/complaint_users/domain/usecases/get_complaint_detail_users_usecase.dart';
import '../../features/users/features/complaint_users/domain/usecases/post_complaint_usecase.dart';
import '../../features/users/features/complaint_users/presentation/bloc/complaint_usres_bloc.dart';
import 'image_compression_service.dart';

final complaintUsersInjec = GetIt.instance; // 🟢 Injeksi khusus untuk complaint

Future<void> complaintUsersServices() async {
  // 🟢 Data Sources
  complaintUsersInjec.registerLazySingleton<ComplaintUsersRemoteDataSource>(
      () => ComplaintUsersRemoteDataSourceImpl(
          complaintUsersInjec(), complaintUsersInjec<ImageProcessor>()));

  // 🟢 Repository
  complaintUsersInjec.registerLazySingleton<ComplaintRepositoryDomainUsers>(
      () => ComplaintUsersRepositoryImpl(complaintUsersInjec()));

  // 🟢 Use Cases
  complaintUsersInjec.registerLazySingleton(
      () => GetAllComplaintsUsersUseCase(complaintUsersInjec()));
  complaintUsersInjec.registerLazySingleton(
      () => GetComplaintDetailUsersUseCase(complaintUsersInjec()));
  complaintUsersInjec
      .registerLazySingleton(() => PostComplaintUseCase(complaintUsersInjec()));
  complaintUsersInjec.registerLazySingleton(
      () => DeleteComplaintUseCase(complaintUsersInjec()));
  complaintUsersInjec
      .registerLazySingleton(() => PutComplaintUseCase(complaintUsersInjec()));

  // 🟢 Bloc
  complaintUsersInjec.registerFactory(() => ComplaintUsersBloc(
        getAllComplaints: complaintUsersInjec(),
        getComplaintDetail: complaintUsersInjec(),
        postComplaintUseCase: complaintUsersInjec(),
        deleteComplaintUseCase: complaintUsersInjec(),
        putComplaintUseCase: complaintUsersInjec(),
      ));
}
