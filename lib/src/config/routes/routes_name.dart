part of "router.dart";

abstract class RouteNames {
  //Authent
  static const splashScreen = '/splash';
  static const login = '/login';
  static const regist = 'regist';

  //Dashboard User
  static const dashboardUser = 'dashboard_user';

  //read meter
  static const getMeter = 'get_meter';
  static const postMeter = 'post_meter';

  //rekening
  static const rekening = 'rekening';

  static const postComplaint =
      '/dashboard_user/list_complaint_users/post_complain';
  static const announcement = 'announcement';
  static const complaint = 'complaint';
  static const listComplaintGet = 'list_complaint';
  static const announcementDetail = 'announcement_detail';
  static const dashboardEmployee = '/dashboard_employee';
  static const listComplaintUsersGet = '/dashboard_user/list_complaint_users';
  static const detailComplaintUsersGet =
      '/dashboard_user/list_complaint_users/detail_complaint_users/:id';
  static const detailComplaintGet = 'detail_complaint/:id';
  static const areaPegawai = 'area_pegawai';
  static const areaPegawaiUsers = '/dashboard_user/area_users';
  static const putUsersProfile = '/dashboard_user/put_users';
  static const rekeningDetail =
      '/dashboard_user/rekening/:pelangganId/detail/:rekeningId';
  static const postRekening =
      '/dashboard_user/rekening/:pelangganId/post_rekening';
  static const putRekening =
      '/dashboard_user/rekening/:pelangganId/detail/:rekeningId/edit/:editRekeningId';
  static const notifikasi = '/dashboard_user/notifikasi';
}
