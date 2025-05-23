import 'package:equatable/equatable.dart';

class PutComplaintEntity extends Equatable {
  final int pengaduanId;
  final int rating;

  const PutComplaintEntity({
    required this.pengaduanId,
    required this.rating,
  });

  @override
  List<Object?> get props => [pengaduanId, rating];
}
