import '../../domain/entities/announcement_entity.dart';

class AnnouncementModel extends Announcement {
  AnnouncementModel({
    required super.id,
    required super.judul,
    required super.content,
    required super.linkFoto,
    required super.tanggalMulai,
    required super.tanggalBerakhir,
    required super.targetScope,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
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
