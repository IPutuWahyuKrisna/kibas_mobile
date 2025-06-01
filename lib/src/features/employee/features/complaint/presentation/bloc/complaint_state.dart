part of 'complaint_bloc.dart';

abstract class ComplaintEmployeeState extends Equatable {
  const ComplaintEmployeeState();

  @override
  List<Object?> get props => [];
}

class ComplaintEmployeeInitial extends ComplaintEmployeeState {}

class ComplaintEmployeeLoading extends ComplaintEmployeeState {}

class ComplaintEmployeeLoaded extends ComplaintEmployeeState {
  final List<ComplaintEmployeeEntity> complaints;

  const ComplaintEmployeeLoaded(this.complaints);

  @override
  List<Object?> get props => [complaints];
}

class ComplaintEmployeeError extends ComplaintEmployeeState {
  final String message;

  const ComplaintEmployeeError(this.message);

  @override
  List<Object?> get props => [message];
}
