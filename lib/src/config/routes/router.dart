import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kibas_mobile/src/core/services/auth_service.dart';
import 'package:kibas_mobile/src/features/users/features/Notification/presentation/pages/notifikasi.dart';
import 'package:kibas_mobile/src/features/users/features/complaint_users/presentation/pages/complaint_users_detail_page.dart';
import 'package:kibas_mobile/src/features/users/features/complaint_users/presentation/pages/complaint_users_list_page.dart';
import 'package:kibas_mobile/src/features/users/features/complaint_users/presentation/pages/post_complaint_page.dart';
import '../../core/utils/user_local_storage_service.dart';
import '../../features/auth/presentation/pages/login.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/employee/features/area_employee/presentation/pages/area_pegawai_page.dart';
import '../../features/employee/features/complaint/presentation/pages/complaint_list_page.dart';
import '../../features/employee/features/dashbord_employee/presentation/pages/dashboard_employee.dart';
import '../../features/users/features/dashboard_user/presentation/pages/announcement_detail.dart';
import '../../features/users/features/read meter/presentation/pages/form_meter_employee.dart';
import '../../features/users/features/read meter/presentation/pages/read_meter_employee.dart';
import '../../features/start pages/presentation/splash__screen.dart';
import '../../features/users/features/dashboard_user/presentation/pages/dashboard_user.dart';
import '../../features/users/features/rekening/presentation/pages/rekening_list_page.dart';
export 'package:go_router/go_router.dart';

part 'routes_name.dart';

final class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static GoRouter get router => _router;

  static final _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    redirect: _redirectLogic,
    routes: [
      _buildSplashRoute(),
      _buildAuthRoutes(),
      _buildEmployeeRoutes(),
      _buildUserRoutes(),
    ],
  );

  static String? _redirectLogic(BuildContext context, GoRouterState state) {
    final userService = authInjec<UserLocalStorageService>();
    final user = userService.getUser();
    final path = state.uri.toString();

    if (user == null) {
      if (path.startsWith('/login') || path.startsWith('/login/regist')) {
        return null;
      }
      return '/login';
    }

    if (user.role == "pembaca-meter") {
      if (path.startsWith('/dashboard_employee/notifikasi') ||
          path.startsWith('/dashboard_employee/list_complaint_employee')) {
        return null;
      }
      return '/dashboard_employee';
    }

    if (user.role == "pelanggan") {
      const allowedPaths = [
        '/dashboard_user/list_complaint_users',
        '/dashboard_user/list_complaint_users/detail_complaint_users/',
        '/dashboard_user/rekening',
        '/dashboard_user/notifikasi',
        '/dashboard_user/list_complaint_users/post_complain',
        '/dashboard_user/rekening/:pelangganId/post_rekening',
        '/dashboard_user/rekening/:pelangganId/detail/:rekeningId/edit/:editRekeningId',
        '/dashboard_user/put_users',
        '/dashboard_user/get_meter',
        '/dashboard_user/detail-pengumuman'
      ];

      if (allowedPaths.any((allowed) => path.startsWith(allowed))) {
        return null;
      }
      return '/dashboard_user';
    }

    return null;
  }

  static GoRoute _buildSplashRoute() {
    return GoRoute(
      path: '/splash',
      name: RouteNames.splashScreen,
      builder: (context, state) => const SplashScreen(),
    );
  }

  static GoRoute _buildAuthRoutes() {
    return GoRoute(
      path: '/login',
      name: RouteNames.login,
      builder: (context, state) => const LoginPages(),
      routes: [
        GoRoute(
          path: 'regist',
          name: RouteNames.regist,
          builder: (context, state) => const RegisterPage(),
        ),
      ],
    );
  }

  static GoRoute _buildEmployeeRoutes() {
    return GoRoute(
      path: '/dashboard_employee',
      name: RouteNames.dashboardEmployee,
      builder: (context, state) => const DashboardEmployeePages(),
      routes: [
        GoRoute(
          path: 'area_pegawai',
          name: RouteNames.areaPegawai,
          builder: (context, state) => const AreaPegawaiPage(),
        ),
        GoRoute(
          path: 'list_complaint',
          name: RouteNames.listComplaintGet,
          builder: (context, state) => const ComplaintEmployeeListPage(),
        ),
      ],
    );
  }

  static GoRoute _buildUserRoutes() {
    return GoRoute(
      path: '/dashboard_user',
      name: RouteNames.dashboardUser,
      builder: (context, state) => const DashboardUserPages(),
      routes: [
        GoRoute(
          path: 'detail-pengumuman',
          name: RouteNames.detailPengumuman,
          builder: (context, state) => const AnnouncementDetail(),
        ),
        GoRoute(
          path: 'notifikasi',
          name: RouteNames.notifikasi,
          builder: (context, state) => const NotificationPages(),
        ),
        GoRoute(
          path: 'rekening',
          name: RouteNames.rekening,
          builder: (context, state) => const RekeningListPage(),
        ),
        GoRoute(
          path: 'get_meter',
          name: RouteNames.getMeter,
          builder: (context, state) => const MeterEmployee(),
          routes: [
            GoRoute(
              path: 'post_meter',
              name: RouteNames.postMeter,
              builder: (context, state) => const FormMeterEmployee(),
            ),
          ],
        ),
        GoRoute(
          path: 'list_complaint_users',
          name: RouteNames.listComplaintUsersGet,
          builder: (context, state) => const ComplaintListUsersPage(),
          routes: [
            GoRoute(
              path: 'post_complain',
              name: RouteNames.postComplaint,
              builder: (context, state) => const PostComplaintPage(),
            ),
            GoRoute(
              path: 'detail_complaint_users/:id',
              name: RouteNames.detailComplaintUsersGet,
              builder: (context, state) {
                final id = int.parse(state.pathParameters['id'] ?? '0');
                return ComplaintDetailUsersPage(id: id);
              },
            ),
          ],
        ),
      ],
    );
  }
}
