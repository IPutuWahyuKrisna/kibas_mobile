part of 'complaint_usres_bloc.dart';

abstract class ComplaintUsersState extends Equatable {
  const ComplaintUsersState();

  @override
  List<Object?> get props => [];
}

class ComplaintUsersInitial extends ComplaintUsersState {}

class ComplaintUsersLoading extends ComplaintUsersState {}

class AllComplaintsUsersLoaded extends ComplaintUsersState {
  final List<ComplaintUsers> complaints;

  const AllComplaintsUsersLoaded({required this.complaints});

  @override
  List<Object?> get props => [complaints];
}

class ComplaintDetailUsersLoaded extends ComplaintUsersState {
  final DetailComplaintUsers complaint;

  const ComplaintDetailUsersLoaded({required this.complaint});

  @override
  List<Object?> get props => [complaint];
}

class PostComplaintSuccess extends ComplaintUsersState {
  final String message;
  const PostComplaintSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class DeleteComplaintSuccess extends ComplaintUsersState {
  final String message;

  const DeleteComplaintSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class ComplaintUsersError extends ComplaintUsersState {
  final String message;

  const ComplaintUsersError({required this.message});

  @override
  List<Object?> get props => [message];
}

class PutComplaintSuccess extends ComplaintUsersState {
  final String message;

  const PutComplaintSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}
