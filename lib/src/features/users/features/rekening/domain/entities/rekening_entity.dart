import 'package:equatable/equatable.dart';

class RekeningEntity extends Equatable {
  final int id;
  final String noRekening;
  final int pelangganId;
  final String lat;
  final String lng;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const RekeningEntity({
    required this.id,
    required this.noRekening,
    required this.pelangganId,
    required this.lat,
    required this.lng,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props =>
      [id, noRekening, pelangganId, lat, lng, createdAt, updatedAt];
}
