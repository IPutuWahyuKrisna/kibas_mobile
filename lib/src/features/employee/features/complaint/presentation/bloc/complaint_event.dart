part of 'complaint_bloc.dart';

abstract class ComplaintEvent extends Equatable {
  const ComplaintEvent();

  @override
  List<Object?> get props => [];
}

class FetchAllComplaintsEvent extends ComplaintEvent {
  final String token;

  const FetchAllComplaintsEvent(this.token);

  @override
  List<Object?> get props => [token];
}

class FetchComplaintDetailEvent extends ComplaintEvent {
  final String token;
  final int id;

  const FetchComplaintDetailEvent(this.token, this.id);

  @override
  List<Object?> get props => [token, id];
}
