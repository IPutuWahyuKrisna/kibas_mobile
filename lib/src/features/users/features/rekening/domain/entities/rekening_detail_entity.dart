import 'package:equatable/equatable.dart';

class RekeningDetailEntity extends Equatable {
  final int id;
  final String noRekening;
  final int pelangganId;
  final int areaId;
  final int kelurahanId;
  final int kecamatanId;
  final int golonganId;
  final int rayonId;
  final double lat;
  final double lng;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const RekeningDetailEntity({
    required this.id,
    required this.noRekening,
    required this.pelangganId,
    required this.areaId,
    required this.kelurahanId,
    required this.kecamatanId,
    required this.golonganId,
    required this.rayonId,
    required this.lat,
    required this.lng,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props =>
      [id, noRekening, pelangganId, lat, lng, createdAt, updatedAt];
}
