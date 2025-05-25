import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import '../../features/users/features/Notification/data/datasources/my_announcement_remote_data_source.dart';
import '../../features/users/features/Notification/data/repositories/my_announcement_repository_impl.dart';
import '../../features/users/features/Notification/domain/repositories/my_announcement_repository.dart';
import '../../features/users/features/Notification/domain/usecases/fetch_my_announcements_usecase.dart';
import '../../features/users/features/Notification/presentation/bloc/notification_bloc.dart';

final sl = GetIt.instance;

void initNotificationInjection() {
  // Data source
  sl.registerLazySingleton<MyAnnouncementRemoteDataSource>(
    () => MyAnnouncementRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<MyAnnouncementRepository>(
    () => MyAnnouncementRepositoryImpl(sl()),
  );

  // Usecase
  sl.registerLazySingleton(() => FetchMyAnnouncementsUseCase(sl()));

  // Bloc
  sl.registerFactory(() => NotificationBloc(sl()));
}
