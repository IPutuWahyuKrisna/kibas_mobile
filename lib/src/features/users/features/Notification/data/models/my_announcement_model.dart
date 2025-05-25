import '../../domain/entities/myannouncement.dart';

class MyAnnouncementModel extends MyAnnouncementEntity {
  const MyAnnouncementModel({
    required super.id,
    required super.judul,
    required super.content,
    required super.linkFoto,
    required super.tanggalMulai,
    required super.tanggalBerakhir,
    required super.targetScope,
  });

  factory MyAnnouncementModel.fromJson(Map<String, dynamic> json) {
    return MyAnnouncementModel(
      id: json['id'],
      judul: json['judul'],
      content: json['content'],
      linkFoto: json['link_foto'],
      tanggalMulai: json['tanggal_mulai'],
      tanggalBerakhir: json['tanggal_berakhir'],
      targetScope: json['target_scope'],
    );
  }
}
