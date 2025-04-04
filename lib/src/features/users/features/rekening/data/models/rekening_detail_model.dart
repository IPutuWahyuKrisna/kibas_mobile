import '../../domain/entities/rekening_detail_entity.dart';

class RekeningDetailModel extends RekeningDetailEntity {
  const RekeningDetailModel({
    required super.id,
    required super.noRekening,
    required super.pelangganId,
    required super.areaId,
    required super.kelurahanId,
    required super.kecamatanId,
    required super.golonganId,
    required super.rayonId,
    required super.lat,
    required super.lng,
    super.createdAt,
    super.updatedAt,
  });

  factory RekeningDetailModel.fromJson(Map<String, dynamic> json) {
    return RekeningDetailModel(
      id: json['id'],
      noRekening: json['no_rekening'],
      pelangganId: json['pelanggan_id'],
      areaId: json['area_id'],
      kelurahanId: json['kelurahan_id'],
      kecamatanId: json['kecamatan_id'],
      golonganId: json['golongan_id'],
      rayonId: json['rayon_id'],
      lat: double.tryParse(json['lat'] ?? '0') ?? 0.0,
      lng: double.tryParse(json['lng'] ?? '0') ?? 0.0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }
}
