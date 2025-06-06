import '../../domain/entities/complaint_entity.dart';

class ComplaintEmployeeModel extends ComplaintEmployee {
  const ComplaintEmployeeModel({
    required super.id,
    required super.pengaduanId,
    required super.namaPelanggan,
    required super.jenisPengaduan,
    required super.linkUrl,
    required super.tanggalPengaduan,
  });

  factory ComplaintEmployeeModel.fromJson(Map<String, dynamic> json) {
    return ComplaintEmployeeModel(
      id: json['id'],
      pengaduanId: json['pengaduan_id'],
      namaPelanggan: json['nama_pelanggan'],
      jenisPengaduan: json['jenis_pengaduan'],
      linkUrl: json['link_url'],
      tanggalPengaduan: DateTime.parse(json['tanggal_pengaduan']),
    );
  }
}
