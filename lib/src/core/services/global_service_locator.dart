import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kibas_mobile/src/core/services/permission_service.dart';

import '../utils/user_local_storage_service.dart';

final coreInjection = GetIt.instance;

void setupCoreServices() {
  // 🟢 Core Services
  coreInjection.registerSingleton<Dio>(Dio());
  coreInjection.registerSingleton<GetStorage>(GetStorage());
  coreInjection
      .registerSingleton<UserLocalStorageService>(UserLocalStorageService());
  coreInjection
      .registerLazySingleton<PermissionService>(() => PermissionService());
}
