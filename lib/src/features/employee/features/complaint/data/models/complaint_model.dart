import '../../domain/entities/complaint_entity.dart';

class ComplaintEmployeeModel extends ComplaintEmployee {
  const ComplaintEmployeeModel({
    required int id,
    required int pengaduanId,
    required String namaPelanggan,
    required String jenisPengaduan,
    required String linkUrl,
    required DateTime tanggalPengaduan,
  }) : super(
          id: id,
          pengaduanId: pengaduanId,
          namaPelanggan: namaPelanggan,
          jenisPengaduan: jenisPengaduan,
          linkUrl: linkUrl,
          tanggalPengaduan: tanggalPengaduan,
        );

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
