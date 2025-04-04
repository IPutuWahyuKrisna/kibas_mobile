part of 'dashboard_user_bloc.dart';

abstract class DashboardUserState extends Equatable {
  const DashboardUserState();

  @override
  List<Object> get props => [];
}

class DashboardUserInitial extends DashboardUserState {}

class DashboardUserStateLoading extends DashboardUserState {}

class PutUserSuccess extends DashboardUserState {
  final String message;
  const PutUserSuccess({required this.message});
}

class PutUserError extends DashboardUserState {
  final String message;
  const PutUserError({required this.message});
}

class DropdownLoading extends DashboardUserState {}

class DropdownLoadedUsers extends DashboardUserState {
  final List<Map<String, dynamic>> golonganList;
  final List<Map<String, dynamic>> kecamatanList;
  final List<Map<String, dynamic>> kelurahanList;
  final List<Map<String, dynamic>> areaList;

  const DropdownLoadedUsers({
    required this.golonganList,
    required this.kecamatanList,
    required this.kelurahanList,
    required this.areaList,
  });
}

class DashboardStateFailure extends DashboardUserState {
  final String message;

  const DashboardStateFailure(this.message);

  @override
  List<Object> get props => [message];
}
