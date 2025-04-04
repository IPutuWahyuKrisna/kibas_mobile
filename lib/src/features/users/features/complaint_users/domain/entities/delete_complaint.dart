import 'package:equatable/equatable.dart';

class DeleteComplaintEntity extends Equatable {
  final int id;
  final String keluhan;
  final int status;
  final String deletedAt;

  const DeleteComplaintEntity({
    required this.id,
    required this.keluhan,
    required this.status,
    required this.deletedAt,
  });

  @override
  List<Object?> get props => [id, keluhan, status, deletedAt];
}
