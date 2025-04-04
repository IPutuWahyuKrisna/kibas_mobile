part of 'dashbord_employee_bloc.dart';

abstract class DashbordEmployeeEvent extends Equatable {
  const DashbordEmployeeEvent();

  @override
  List<Object?> get props => [];
}

class GetAnnouncementsEvent extends DashbordEmployeeEvent {
  final String token;

  const GetAnnouncementsEvent(this.token);

  @override
  List<Object?> get props => [token];
}

class LogoutEvent extends DashbordEmployeeEvent {}
