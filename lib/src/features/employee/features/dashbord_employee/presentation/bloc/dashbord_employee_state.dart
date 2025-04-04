part of 'dashbord_employee_bloc.dart';

abstract class DashbordEmployeeState extends Equatable {
  const DashbordEmployeeState();

  @override
  List<Object?> get props => [];
}

class DashbordEmployeeInitial extends DashbordEmployeeState {}

class DashboardLoading extends DashbordEmployeeState {}

class DashboardLoaded extends DashbordEmployeeState {
  final List<Announcement> announcements;

  const DashboardLoaded(this.announcements);

  @override
  List<Object?> get props => [announcements];
}

class DashboardError extends DashbordEmployeeState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}

class DashboardLoggedOut extends DashbordEmployeeState {
  final String message;

  const DashboardLoggedOut(this.message);

  @override
  List<Object?> get props => [message];
}
