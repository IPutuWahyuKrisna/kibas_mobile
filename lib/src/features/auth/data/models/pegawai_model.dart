import '../../domain/entities/pegawai_entity.dart';

class PegawaiModel extends Pegawai {
  PegawaiModel({
    required super.id,
    required super.nama,
    required super.jabatan,
    required super.areaBertugas,
  });

  factory PegawaiModel.fromJson(Map<String, dynamic> json) {
    return PegawaiModel(
      id: json['id'],
      nama: json['nama'],
      jabatan: json['jabatan'],
      areaBertugas: List<String>.from(
          (json['area_bertugas'] ?? []).map((e) => e['area'])),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'jabatan': jabatan,
      'area_bertugas': areaBertugas.map((e) => {'area': e}).toList(),
    };
  }
}
