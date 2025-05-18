import '../../domain/entities/complaint_entity.dart';

class ComplaintModel extends Complaint {
  ComplaintModel({
    required super.id,
    required super.keluhan,
    required super.linkFoto,
    required super.status,
    required super.pelangganId,
    required super.namaPelanggan,
    super.createdAt,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      id: json['id'],
      keluhan: json['keluhan'],
      linkFoto: json['link_foto'],
      status: json['status'],
      pelangganId: json['pelanggan_id'],
      namaPelanggan: json['nama_pelanggan'] ?? "",
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'keluhan': keluhan,
      'link_foto': linkFoto,
      'status': status,
      'pelanggan_id': pelangganId,
      'nama_pelanggan': namaPelanggan,
      'created_at': createdAt,
    };
  }
}
