part of 'area_employee_bloc.dart';

abstract class AreaEmployeeState extends Equatable {
  const AreaEmployeeState();

  @override
  List<Object?> get props => [];
}

class AreaPegawaiInitial extends AreaEmployeeState {}

class AreaPegawaiLoading extends AreaEmployeeState {}

class AreaPegawaiLoaded extends AreaEmployeeState {
  final AreaPegawai areaPegawai;

  const AreaPegawaiLoaded({required this.areaPegawai});

  @override
  List<Object?> get props => [areaPegawai];
}

class AreaPegawaiError extends AreaEmployeeState {
  final String message;

  const AreaPegawaiError({required this.message});

  @override
  List<Object?> get props => [message];
}
