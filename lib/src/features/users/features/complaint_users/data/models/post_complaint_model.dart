import '../../domain/entities/post_complaint_entity.dart';

class PostComplaintModel extends PostComplaintEntity {
  const PostComplaintModel({
    required super.image,
    required super.complaint,
    required super.latitude,
    required super.longitude,
    required super.jenisPengaduan,
  });

  Map<String, dynamic> toJson() {
    return {
      "complaint": complaint,
      "latitude": latitude,
      "longitude": longitude,
      "jenis_pengaduan": jenisPengaduan,
      // Untuk image, gunakan FormData saat mengirim (tidak ditaruh di toJson langsung)
    };
  }

  factory PostComplaintModel.fromEntity(PostComplaintEntity entity) {
    return PostComplaintModel(
      image: entity.image,
      complaint: entity.complaint,
      latitude: entity.latitude,
      longitude: entity.longitude,
      jenisPengaduan: entity.jenisPengaduan,
    );
  }
}
