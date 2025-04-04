import '../../domain/entities/delete_complaint.dart';

class DeleteComplaintModel extends DeleteComplaintEntity {
  const DeleteComplaintModel({
    required super.id,
    required super.keluhan,
    required super.status,
    required super.deletedAt,
  });

  factory DeleteComplaintModel.fromJson(Map<String, dynamic> json) {
    return DeleteComplaintModel(
      id: json['id'],
      keluhan: json['keluhan'],
      status: json['status'],
      deletedAt: json['deleted_at'] ?? "Aktif",
    );
  }
}
