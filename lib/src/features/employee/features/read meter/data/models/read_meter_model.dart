import '../../domain/entities/read_meter.dart';

class ReadMeterModel extends ReadMeter {
  ReadMeterModel({
    required super.noRekening,
    required super.linkFoto,
    required super.angkaFinal,
    super.createdAt,
  });

  factory ReadMeterModel.fromJson(Map<String, dynamic> json) {
    return ReadMeterModel(
      noRekening: json['no_rekening'] ?? '',
      linkFoto: json['link_foto'] ?? '',
      angkaFinal: json['angka_final'] ?? 0,
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'no_rekening': noRekening,
      'link_foto': linkFoto,
      'angka_final': angkaFinal,
      'created_at': createdAt,
    };
  }
}
