import 'package:go_router/go_router.dart';
import 'package:kibas_mobile/src/core/services/auth_service.dart';
import 'package:kibas_mobile/src/features/users/features/complaint_users/presentation/pages/complaint_users_detail_page.dart';
import 'package:kibas_mobile/src/features/users/features/complaint_users/presentation/pages/complaint_usres_list_page.dart';
import 'package:kibas_mobile/src/features/users/features/complaint_users/presentation/pages/post_complaint_page.dart';
import 'package:kibas_mobile/src/features/users/features/rekening/presentation/pages/put_rekening_page.dart';
import '../../core/utils/user_local_storage_service.dart';
import '../../features/auth/presentation/pages/login.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/employee/features/area_employee/presentation/pages/area_pegawai_page.dart';
import '../../features/employee/features/complaint/presentation/pages/complaint_detail_page.dart';
import '../../features/employee/features/complaint/presentation/pages/complaint_list_page.dart';
import '../../features/employee/features/dashbord_employee/presentation/pages/dashboard_employee.dart';
import '../../features/employee/features/read meter/presentation/pages/form_meter_employee.dart';
import '../../features/employee/features/read meter/presentation/pages/read_meter_employee.dart';
import '../../features/start pages/presentation/splash__screen.dart';
import '../../features/users/features/area_employee_users/area_pegawai_users_page.dart';
import '../../features/users/features/dashboard_user/presentation/pages/dashboard_user.dart';
import '../../features/users/features/dashboard_user/presentation/pages/put_user_page.dart';
import '../../features/users/features/rekening/presentation/pages/post_rekening_page.dart';
import '../../features/users/features/rekening/presentation/pages/rekening_detail_page.dart';
import '../../features/users/features/rekening/presentation/pages/rekening_list_page.dart';
export 'package:go_router/go_router.dart';

part 'routes_name.dart';

final class AppRouter {
  static final router = GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
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
        if (path.startsWith('/dashboard_employee/read_meter_employee')) {
          return null;
        }
        if (path.startsWith('/dashboard_employee/area_pegawai')) {
          return null;
        }
        if (path.startsWith('/dashboard_employee/list_complaint')) {
          return null;
        }
        return '/dashboard_employee';
      }

      if (user.role == "pelanggan") {
        if (path.startsWith('/dashboard_user/area_users')) {
          return null;
        }
        if (path.startsWith('/dashboard_user/list_complaint_users')) {
          return null;
        }
        if (path.startsWith(
            '/dashboard_user/list_complaint_users/detail_complaint_users/')) {
          return null;
        }
        if (path.startsWith('/dashboard_user/rekening/')) {
          return null;
        }
        if (path
            .startsWith('/dashboard_user/list_complaint_users/post_complain')) {
          return null;
        }
        if (path.startsWith(
            '/dashboard_user/rekening/:pelangganId/post_rekening')) {
          return null;
        }
        if (path.startsWith(
            '/dashboard_user/rekening/:pelangganId/detail/:rekeningId/edit/:editRekeningId')) {
          return null;
        }
        if (path.startsWith('/dashboard_user/put_users')) {
          return null;
        }
        return '/dashboard_user';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        name: RouteNames.splashScreen,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
          path: '/login',
          name: RouteNames.login,
          builder: (context, state) => const LoginPages(),
          routes: [
            GoRoute(
              path: 'regist',
              name: RouteNames.regist,
              builder: (context, state) => const RegisterPage(),
            ),
          ]),
      GoRoute(
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
              builder: (context, state) => const ComplaintListPage(),
              routes: [
                GoRoute(
                  path: 'detail_complaint/:id',
                  name: RouteNames.detailComplaintGet,
                  builder: (context, state) {
                    final id = int.parse(state.pathParameters['id'] ?? '0');
                    return ComplaintDetailPage(id: id);
                  },
                ),
              ]),
          GoRoute(
            path: 'read_meter_employee',
            name: RouteNames.meterEmployee,
            builder: (context, state) => const MeterEmployee(),
            routes: [
              GoRoute(
                path: 'form_meter_employee',
                name: RouteNames.addMeterEmployee,
                builder: (context, state) => const FormMeterEmployee(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/dashboard_user',
        name: RouteNames.dashboardUser,
        builder: (context, state) => const DashboardUserPages(),
        routes: [
          GoRoute(
            path: 'area_users',
            name: RouteNames.areaPegawaiUsers,
            builder: (context, state) => const AreaPegawaiUserPage(),
          ),
          GoRoute(
            path: 'put_users',
            name: RouteNames.putUsersProfile,
            builder: (context, state) => const PutUsersPage(),
          ),
          GoRoute(
            path: 'rekening/:pelangganId',
            name: RouteNames.rekeningList,
            builder: (context, state) {
              final pelangganId =
                  int.tryParse(state.pathParameters['pelangganId'] ?? '0') ?? 0;
              return RekeningListPage(pelangganId: pelangganId);
            },
            routes: [
              GoRoute(
                path: 'post_rekening',
                name: RouteNames.postRekening,
                builder: (context, state) => const PostRekeningPage(),
              ),
              GoRoute(
                  path:
                      'detail/:rekeningId', // 🔥 Sub-route tidak pakai '/dashboard_user/rekening/'
                  name: RouteNames.rekeningDetail,
                  builder: (context, state) {
                    final rekeningId = int.tryParse(
                            state.pathParameters['rekeningId'] ?? '0') ??
                        0;
                    return RekeningDetailPage(rekeningId: rekeningId);
                  },
                  routes: [
                    GoRoute(
                      path: 'edit/:editRekeningId',
                      name: RouteNames.putRekening,
                      builder: (context, state) {
                        final editrekeningId = int.tryParse(
                                state.pathParameters['editRekeningId'] ??
                                    '0') ??
                            0;
                        return PutRekeningPage(editRekeningId: editrekeningId);
                      },
                    ),
                  ]),
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
      ),
    ],
  );
}
