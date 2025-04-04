import '../../domain/entities/area_pegawai_entity.dart';

class AreaPegawaiModel extends AreaPegawai {
  AreaPegawaiModel({
    required super.id,
    required super.pegawaiName,
    required super.areaBertugas,
  });

  factory AreaPegawaiModel.fromJson(Map<String, dynamic> json) {
    return AreaPegawaiModel(
      id: json['id'],
      pegawaiName: json['pegawai_name'],
      areaBertugas: json['area_bertugas']
          .toString()
          .split(', '), // 🟢 Pisahkan area bertugas jadi List<String>
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pegawai_name': pegawaiName,
      'area_bertugas':
          areaBertugas.join(', '), // 🟢 Gabungkan List<String> jadi String
    };
  }
}
