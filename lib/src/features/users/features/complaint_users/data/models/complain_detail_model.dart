import 'package:intl/intl.dart';
import 'package:kibas_mobile/src/features/users/features/complaint_users/domain/entities/detail_complain.dart';

class DetailComplaintModelUsers extends DetailComplaintUsers {
  DetailComplaintModelUsers({
    required super.id,
    required super.pelangganId,
    required super.namaPelanggan,
    super.linkUrl,
    required super.status,
    super.rating,
    super.tanggalPengaduan,
    required super.tanggalSelesai,
    required super.keteranganSelesai,
    required super.jenisPengaduan,
    required super.namaPegawai,
    required super.buktiFotoSelesai,
  });

  factory DetailComplaintModelUsers.fromJson(Map<String, dynamic> json) {
    return DetailComplaintModelUsers(
      id: json['id'],
      pelangganId: json['pelanggan_id'],
      namaPelanggan: json['nama_pelanggan'],
      linkUrl: json['link_url'],
      status: json['status'],
      rating: json['rating'],
      tanggalPengaduan: _parseDate(json['tanggal_pengaduan']),
      tanggalSelesai: json['tanggal_selesai'],
      keteranganSelesai: json['keterangan_selesai'],
      jenisPengaduan: json['jenis_pengaduan'],
      namaPegawai: json['nama_pegawai'],
      buktiFotoSelesai: json['bukti_foto_selesai'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pelanggan_id': pelangganId,
      'nama_pelanggan': namaPelanggan,
      'link_url': linkUrl,
      'status': status,
      'rating': rating,
      'tanggal_pengaduan': tanggalPengaduan?.toIso8601String(),
      'tanggal_selesai': tanggalSelesai,
      'keterangan_selesai': keteranganSelesai,
      'jenis_pengaduan': jenisPengaduan,
      'nama_pegawai': namaPegawai,
      'bukti_foto_selesai': buktiFotoSelesai,
    };
  }

  static DateTime? _parseDate(String? dateStr) {
    try {
      if (dateStr == null || dateStr == '-') return null;
      return DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateStr);
    } catch (_) {
      return null;
    }
  }
}
