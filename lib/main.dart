import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kibas_mobile/firebase_options.dart';
import 'package:kibas_mobile/src/core/services/auth_service.dart';
import 'package:kibas_mobile/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:kibas_mobile/src/features/users/features/rekening/presentation/bloc/rekening_bloc.dart';
import 'src/config/routes/router.dart';
import 'src/core/services/area_pegawai_services.dart';
import 'src/core/services/complaint_services.dart';
import 'src/core/services/complaint_users_services.dart';
import 'src/core/services/dashboard_employee_services.dart';
import 'src/core/services/fcm/fcm_handler.dart';
import 'src/core/services/fcm/notification_service.dart';
import 'src/core/services/global_service_locator.dart';
import 'src/core/services/notification_injection.dart';
import 'src/core/services/permission_service.dart';
import 'src/core/services/put_user_services.dart';
import 'src/core/services/read_meter_services.dart';
import 'src/core/services/rekening_injec.dart';
import 'src/features/users/features/Notification/presentation/bloc/notification_bloc.dart';
import 'src/features/users/features/Notification/presentation/pages/notifikasi.dart';
import 'src/features/users/features/read meter/presentation/bloc/read_meter_bloc.dart';
import 'src/features/users/features/complaint_users/presentation/bloc/complaint_usres_bloc.dart';
import 'src/features/users/features/dashboard_user/presentation/bloc/dashboard_user_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initNotificationInjection();
  setupCoreServices();
  setupAuthServices();
  setupDashboardServices();
  initMeterServices();
  initComplaintServices();
  complaintUsersServices();
  initAreaPegawaiServices();
  initPutUsersProfile();
  initRekeningModule();
  await coreInjection<PermissionService>().requestPermissions();
  await NotificationService.initialize(); // init local notif
  await FCMHandler.initialize(); // init fcm listener
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => authInjec<AuthBloc>(),
        ),
        BlocProvider<ReadMeterBloc>(
          create: (_) => meterInjec<ReadMeterBloc>(),
        ),
        BlocProvider<ComplaintUsersBloc>(
          create: (_) => complaintUsersInjec<ComplaintUsersBloc>(),
        ),
        BlocProvider<DashboardUserBloc>(
          create: (_) => putUserInjec<DashboardUserBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<NotificationBloc>(),
          child: const NotificationPages(),
        ),
        BlocProvider<RekeningBloc>(
          create: (_) => rekeningInjec<RekeningBloc>(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
