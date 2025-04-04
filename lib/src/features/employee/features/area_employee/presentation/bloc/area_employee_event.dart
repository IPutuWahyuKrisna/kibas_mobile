part of 'area_employee_bloc.dart';

abstract class AreaEmployeeEvent extends Equatable {
  const AreaEmployeeEvent();

  @override
  List<Object?> get props => [];
}

class FetchAreaPegawaiEvent extends AreaEmployeeEvent {
  final String token;

  const FetchAreaPegawaiEvent(this.token);

  @override
  List<Object?> get props => [token];
}
