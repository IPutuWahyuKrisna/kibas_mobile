part of 'dashboard_user_bloc.dart';

abstract class DashboardUserEvent extends Equatable {
  const DashboardUserEvent();

  @override
  List<Object> get props => [];
}

/// 🔹 Submit Data Register
class PutUsersEvent extends DashboardUserEvent {
  final PutUserProfileEntity putUsers;
  const PutUsersEvent({required this.putUsers});
}

/// 🔹 Fetch Dropdown Data
class FetchDropdownEvent extends DashboardUserEvent {}
