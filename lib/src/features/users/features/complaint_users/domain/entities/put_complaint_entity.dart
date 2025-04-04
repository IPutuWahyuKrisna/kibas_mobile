import 'package:equatable/equatable.dart';

class PutComplaintEntity extends Equatable {
  final int id;
  final String keluhan;
  final int pelangganId;

  const PutComplaintEntity({
    required this.id,
    required this.keluhan,
    required this.pelangganId,
  });

  @override
  List<Object?> get props => [id, keluhan, pelangganId];
}
