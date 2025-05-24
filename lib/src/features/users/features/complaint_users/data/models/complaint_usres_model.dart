import '../../domain/entities/complaint_users_entity.dart';

class ComplaintModelUsers extends ComplaintUsers {
  const ComplaintModelUsers({
    required super.id,
    required super.pelangganId,
    super.linkUrl,
    super.pengaduanLat,
    super.pengaduanLong,
    required super.status,
    super.rating,
    required super.tanggalPengaduan,
    super.tanggalSelesai,
    super.keteranganSelesai,
    required super.jenisPengaduan,
  });

  factory ComplaintModelUsers.fromJson(Map<String, dynamic> json) {
    return ComplaintModelUsers(
      id: json['id'] as int,
      pelangganId: json['pelanggan_id'] as int,
      linkUrl: json['link_url'] as String?,
      pengaduanLat: json['pengaduan_lat'] != null
          ? double.tryParse(json['pengaduan_lat'].toString())
          : null,
      pengaduanLong: json['pengaduan_long'] != null
          ? double.tryParse(json['pengaduan_long'].toString())
          : null,
      status: json['status'] as String,
      rating: json['rating'] as int?,
      tanggalPengaduan: DateTime.parse(json['tanggal_pengaduan']),
      tanggalSelesai: json['tanggal_selesai'] != null
          ? DateTime.parse(json['tanggal_selesai'])
          : null,
      keteranganSelesai: json['keterangan_selesai'] as String?,
      jenisPengaduan: json['jenis_pengaduan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pelanggan_id': pelangganId,
      'link_url': linkUrl,
      'pengaduan_lat': pengaduanLat?.toStringAsFixed(7),
      'pengaduan_long': pengaduanLong?.toStringAsFixed(7),
      'status': status,
      'rating': rating,
      'tanggal_pengaduan': tanggalPengaduan.toIso8601String(),
      'tanggal_selesai': tanggalSelesai?.toIso8601String(),
      'keterangan_selesai': keteranganSelesai,
      'jenis_pengaduan': jenisPengaduan,
    };
  }
}
