import '../../domain/entities/complaint_users_entity.dart';

class ComplaintModelUsers extends ComplaintUsers {
  ComplaintModelUsers({
    required super.id,
    required super.keluhan,
    required super.linkFoto,
    required super.status,
    required super.pelangganId,
    required super.namaPelanggan,
    super.createdAt,
  });

  factory ComplaintModelUsers.fromJson(Map<String, dynamic> json) {
    return ComplaintModelUsers(
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
