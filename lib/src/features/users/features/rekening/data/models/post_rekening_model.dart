import '../../domain/entities/post_rekening.dart';

class RekeningModel extends PostRekeningEntity {
  const RekeningModel({
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

  factory RekeningModel.fromJson(Map<String, dynamic> json) {
    return RekeningModel(
      noRekening: json['no_rekening'] ?? "",
      pelangganId: json['pelanggan_id'] ?? 0,
      areaId: json['area_id'] ?? 0,
      kelurahanId: json['kelurahan_id'] ?? 0,
      kecamatanId: json['kecamatan_id'] ?? 0,
      golonganId: json['golongan_id'] ?? 0,
      rayonId: json['rayon_id'] ?? 0,
      lat: json['lat'].toString(),
      lng: json['lng'].toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "no_rekening": noRekening,
      "pelanggan_id": pelangganId,
      "area_id": areaId,
      "kelurahan_id": kelurahanId,
      "kecamatan_id": kecamatanId,
      "golongan_id": golonganId,
      "rayon_id": rayonId,
      "lat": lat,
      "lng": lng,
    };
  }
}
