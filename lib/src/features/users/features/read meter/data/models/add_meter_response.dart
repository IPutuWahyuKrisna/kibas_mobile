import '../../domain/entities/post_meter.dart';

class PostMeterModel extends PostmeterEntity {
  const PostMeterModel({
    required super.linkFoto,
    required super.angkaFinal,
  });

  // Convert dari JSON ke Model
  factory PostMeterModel.fromJson(Map<String, dynamic> json) {
    return PostMeterModel(
      linkFoto: json['link_foto'],
      angkaFinal: json['angka_final'],
    );
  }

  // Convert dari Model ke JSON (untuk dikirim ke API)
  Map<String, dynamic> toJson() {
    return {"link_foto": linkFoto, "angka_final": angkaFinal};
  }
}
