import '../../domain/entities/put_complaint_entity.dart';

class PutComplaintModel extends PutComplaintEntity {
  const PutComplaintModel({
    required super.pengaduanId,
    required super.rating,
  });

  factory PutComplaintModel.fromJson(Map<String, dynamic> json) {
    return PutComplaintModel(
      pengaduanId: json['pengaduan_id'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pengaduan_id': pengaduanId,
      'rating': rating,
    };
  }

  factory PutComplaintModel.fromEntity(PutComplaintEntity entity) {
    return PutComplaintModel(
      pengaduanId: entity.pengaduanId,
      rating: entity.rating,
    );
  }
}
