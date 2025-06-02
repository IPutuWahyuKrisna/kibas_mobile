part of 'complaint_bloc.dart';

enum ComplaintFailureType {
  unauthenticated,
  server,
  network,
  unknown,
}

abstract class ComplaintState extends Equatable {
  const ComplaintState();

  @override
  List<Object> get props => [];
}

class ComplaintInitial extends ComplaintState {}

class ComplaintLoading extends ComplaintState {}

class ComplaintSubmitting extends ComplaintState {}

class ComplaintLoaded extends ComplaintState {
  final List<ComplaintEmployee> complaints;

  const ComplaintLoaded({required this.complaints});

  @override
  List<Object> get props => [complaints];
}

class ComplaintSubmittedSuccess extends ComplaintState {
  final String message;

  const ComplaintSubmittedSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class ComplaintError extends ComplaintState {
  final String message;
  final ComplaintFailureType failureType;

  const ComplaintError({
    required this.message,
    required this.failureType,
  });

  @override
  List<Object> get props => [message, failureType];
}
