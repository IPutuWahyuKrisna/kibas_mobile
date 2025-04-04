part of 'complaint_bloc.dart';

abstract class ComplaintState extends Equatable {
  const ComplaintState();

  @override
  List<Object?> get props => [];
}

class ComplaintInitial extends ComplaintState {}

class ComplaintLoading extends ComplaintState {}

class AllComplaintsLoaded extends ComplaintState {
  final List<Complaint> complaints;

  const AllComplaintsLoaded({required this.complaints});

  @override
  List<Object?> get props => [complaints];
}

class ComplaintDetailLoaded extends ComplaintState {
  final Complaint complaint;

  const ComplaintDetailLoaded({required this.complaint});

  @override
  List<Object?> get props => [complaint];
}

class ComplaintError extends ComplaintState {
  final String message;

  const ComplaintError({required this.message});

  @override
  List<Object?> get props => [message];
}
