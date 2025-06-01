part of 'complaint_bloc.dart';

abstract class ComplaintEmployeeEvent extends Equatable {
  const ComplaintEmployeeEvent();

  @override
  List<Object?> get props => [];
}

class GetAllComplaintEmployeeEvent extends ComplaintEmployeeEvent {}
