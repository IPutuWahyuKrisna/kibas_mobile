part of 'complaint_usres_bloc.dart';

abstract class ComplaintUsersEvent extends Equatable {
  const ComplaintUsersEvent();

  @override
  List<Object?> get props => [];
}

class FetchAllComplaintsUsersEvent extends ComplaintUsersEvent {
  final String token;

  const FetchAllComplaintsUsersEvent(this.token);

  @override
  List<Object?> get props => [token];
}

class FetchComplaintDetailUsersEvent extends ComplaintUsersEvent {
  final String token;
  final int id;

  const FetchComplaintDetailUsersEvent(this.token, this.id);

  @override
  List<Object?> get props => [token, id];
}

class SubmitComplaintEvent extends ComplaintUsersEvent {
  final File image;
  final String complaint;

  const SubmitComplaintEvent({
    required this.image,
    required this.complaint,
  });

  @override
  List<Object?> get props => [image, complaint];
}

class DeleteComplaintEvent extends ComplaintUsersEvent {
  final int id;

  const DeleteComplaintEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class SubmitPutComplaintEvent extends ComplaintUsersEvent {
  final PutComplaintModel putComplaint;

  const SubmitPutComplaintEvent({required this.putComplaint});

  @override
  List<Object> get props => [putComplaint];
}
