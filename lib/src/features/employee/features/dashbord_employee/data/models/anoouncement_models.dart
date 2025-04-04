import '../../domain/entities/announcement_entity.dart';

class AnnouncementModel extends Announcement {
  AnnouncementModel({
    required super.id,
    required super.pengumuman,
    required super.judul,
    required super.penulis,
    required super.linkFoto,
    required super.areaId,
    required super.areaName,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'],
      pengumuman: json['pengumuman'],
      judul: json['judul'],
      penulis: json['penulis'],
      linkFoto: json['link_foto'],
      areaId: json['area_id'],
      areaName: json['area_name'],
    );
  }
}
