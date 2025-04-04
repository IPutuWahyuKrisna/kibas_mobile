part of "router.dart";

abstract class RouteNames {
  static const splashScreen = '/splash';
  static const login = '/login';
  static const regist = 'regist';
  static const dashboardUser = '/dashboard_user';
  static const dashboardEmployee = '/dashboard_employee';
  static const meterEmployee = 'read_meter_employee';
  static const addMeterEmployee = 'form_meter_employee';
  static const announcement = 'announcement';
  static const complaint = 'complaint';
  static const announcementDetail = 'announcement_detail';
  static const listComplaintGet = 'list_complaint';
  static const postComplaint =
      '/dashboard_user/list_complaint_users/post_complain';
  static const listComplaintUsersGet = '/dashboard_user/list_complaint_users';
  static const detailComplaintUsersGet =
      '/dashboard_user/list_complaint_users/detail_complaint_users/:id';
  static const detailComplaintGet = 'detail_complaint/:id';
  static const areaPegawai = 'area_pegawai';
  static const areaPegawaiUsers = '/dashboard_user/area_users';
  static const putUsersProfile = '/dashboard_user/put_users';
  static const rekeningList = '/dashboard_user/rekening/:pelangganId';
  static const rekeningDetail =
      '/dashboard_user/rekening/:pelangganId/detail/:rekeningId';
  static const postRekening =
      '/dashboard_user/rekening/:pelangganId/post_rekening';
  static const putRekening =
      '/dashboard_user/rekening/:pelangganId/detail/:rekeningId/edit/:editRekeningId';
}
