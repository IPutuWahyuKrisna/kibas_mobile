import '../../domain/entities/rekening_entity.dart';

class RekeningModel extends RekeningEntity {
  const RekeningModel({
    required super.id,
    required super.noRekening,
    required super.pelangganId,
    required super.lat,
    required super.lng,
    super.createdAt,
    super.updatedAt,
  });

  factory RekeningModel.fromJson(Map<String, dynamic> json) {
    return RekeningModel(
      id: (json['id'] is int)
          ? json['id']
          : int.tryParse(json['id'].toString()) ??
              0, // 🔥 Pastikan id selalu int
      noRekening: json['no_rekening']?.toString() ?? "",
      pelangganId: (json['pelanggan_id'] is int)
          ? json['pelanggan_id']
          : int.tryParse(json['pelanggan_id'].toString()) ??
              0, // 🔥 Pastikan pelanggan_id selalu int
      lat: json['lat']?.toString() ?? "0.0", // 🔥 Pastikan lat tetap String
      lng: json['lng']?.toString() ?? "0.0", // 🔥 Pastikan lng tetap String
      createdAt: json['created_at'] != null && json['created_at'] != ""
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null && json['updated_at'] != ""
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "no_rekening": noRekening,
      "pelanggan_id": pelangganId,
      "lat": lat,
      "lng": lng,
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
    };
  }
}
