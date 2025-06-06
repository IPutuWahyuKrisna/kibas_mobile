part of "router.dart";

abstract class RouteNames {
  //Authentication
  static const splashScreen = '/splash';
  static const login = '/login';
  static const regist = 'regist';

  //User
  static const dashboardUser = 'dashboard_user';
  static const detailPengumuman = 'detailPengumuman';
  static const notifikasi = '/dashboard_user/notifikasi';
  static const rekening = 'rekening';
  static const rekeningDetail =
      '/dashboard_user/rekening/:pelangganId/detail/:rekeningId';
  static const postRekening =
      '/dashboard_user/rekening/:pelangganId/post_rekening';
  static const getMeter = 'get_meter';
  static const postMeter = 'post_meter';
  static const listComplaintUsersGet = '/dashboard_user/list_complaint_users';
  static const postComplaint =
      '/dashboard_user/list_complaint_users/post_complain';
  static const detailComplaintUsersGet =
      '/dashboard_user/list_complaint_users/detail_complaint_users/:id';

  //Pegawai
  static const dashboardEmployee = '/dashboard_employee';
  static const listComplaintGet = 'list_complaint_employee';
  static const editComplaintEmployee = 'edit_complaint/:id';

  static const complaint = 'complaint';
  static const announcementDetail = 'announcement_detail';
  static const areaPegawai = 'area_pegawai';
  static const areaPegawaiUsers = '/dashboard_user/area_users';
  static const putUsersProfile = '/dashboard_user/put_users';
  static const announcement = 'announcement';
  static const putRekening =
      '/dashboard_user/rekening/:pelangganId/detail/:rekeningId/edit/:editRekeningId';
}
