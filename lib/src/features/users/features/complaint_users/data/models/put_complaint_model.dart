import '../../domain/entities/put_complaint_entity.dart';

class PutComplaintModel extends PutComplaintEntity {
  const PutComplaintModel({
    required super.id,
    required super.keluhan,
    required super.pelangganId,
  });

  factory PutComplaintModel.fromJson(Map<String, dynamic> json) {
    return PutComplaintModel(
      id: json['id'],
      keluhan: json['keluhan'],
      pelangganId: json['pelanggan_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "keluhan": keluhan,
      "pelanggan_id": pelangganId,
    };
  }
}
