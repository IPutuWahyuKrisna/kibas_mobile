import '../../domain/entities/pelanggan_entity.dart';

class PelangganModel extends Pelanggan {
  PelangganModel({
    required super.id,
    required super.noPelanggan,
    required super.namaPelanggan,
    required super.nikPelanggan,
    required super.alamatPelanggan,
    required super.kecamatan,
    required super.area,
    required super.rekening,
  });

  factory PelangganModel.fromJson(Map<String, dynamic> json) {
    return PelangganModel(
      id: json['id'],
      noPelanggan: json['no_pelanggan'],
      namaPelanggan: json['nama_pelanggan'],
      nikPelanggan: json['nik_pelanggan'],
      alamatPelanggan: json['alamat_pelanggan'],
      kecamatan: json['location']?['kecamatan']?['kecamatan'] ?? '',
      area: json['location']?['area']?['area'] ?? '',
      rekening: List<String>.from(
          (json['rekening'] ?? []).map((e) => e['no_rekening'])),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'no_pelanggan': noPelanggan,
      'nama_pelanggan': namaPelanggan,
      'nik_pelanggan': nikPelanggan,
      'alamat_pelanggan': alamatPelanggan,
      'location': {
        'kecamatan': {'kecamatan': kecamatan},
        'area': {'area': area},
      },
      'rekening': rekening.map((e) => {'no_rekening': e}).toList(),
    };
  }
}
