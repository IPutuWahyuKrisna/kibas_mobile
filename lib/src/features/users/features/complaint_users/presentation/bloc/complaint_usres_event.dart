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
  final double latitude;
  final double longitude;
  final String jenisPengaduan;

  const SubmitComplaintEvent({
    required this.image,
    required this.complaint,
    required this.latitude,
    required this.longitude,
    required this.jenisPengaduan,
  });

  @override
  List<Object?> get props =>
      [image, complaint, latitude, longitude, jenisPengaduan];
}

class DeleteComplaintEvent extends ComplaintUsersEvent {
  final int id;

  const DeleteComplaintEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class SubmitRatingComplaintEvent extends ComplaintUsersEvent {
  final int pengaduanId;
  final int rating;

  const SubmitRatingComplaintEvent({
    required this.pengaduanId,
    required this.rating,
  });

  @override
  List<Object?> get props => [pengaduanId, rating];
}
