// complaint_entity.dart
import 'package:equatable/equatable.dart';

class ComplaintEmployee extends Equatable {
  final int id;
  final int pengaduanId;
  final String namaPelanggan;
  final String jenisPengaduan;
  final String linkUrl;
  final DateTime tanggalPengaduan;

  const ComplaintEmployee({
    required this.id,
    required this.pengaduanId,
    required this.namaPelanggan,
    required this.jenisPengaduan,
    required this.linkUrl,
    required this.tanggalPengaduan,
  });

  factory ComplaintEmployee.fromJson(Map<String, dynamic> json) {
    return ComplaintEmployee(
      id: json['id'],
      pengaduanId: json['pengaduan_id'],
      namaPelanggan: json['nama_pelanggan'],
      jenisPengaduan: json['jenis_pengaduan'],
      linkUrl: json['link_url'],
      tanggalPengaduan: DateTime.parse(json['tanggal_pengaduan']),
    );
  }

  @override
  List<Object?> get props => [
        id,
        pengaduanId,
        namaPelanggan,
        jenisPengaduan,
        linkUrl,
        tanggalPengaduan,
      ];
}
