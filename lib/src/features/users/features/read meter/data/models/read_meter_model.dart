import '../../domain/entities/read_meter.dart';

class ReadMeterModel extends ReadMeterEntity {
  const ReadMeterModel({
    required super.id,
    required super.linkFoto,
    required super.status,
    required super.angkaFinal,
    required super.keterangan,
    required super.createdAt,
  });

  factory ReadMeterModel.fromJson(Map<String, dynamic> json) {
    return ReadMeterModel(
      id: json['id'],
      linkFoto: json['link_foto'],
      status: json['status'],
      angkaFinal: json['angka_final'],
      keterangan: json['keterangan'],
      createdAt: json['created_at'],
    );
  }
}
