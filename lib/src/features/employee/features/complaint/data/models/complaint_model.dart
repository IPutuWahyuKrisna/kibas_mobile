import '../../domain/entities/complaint_entity.dart';

class ComplaintEmployeeModel extends ComplaintEmployeeEntity {
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pengaduan_id': pengaduanId,
      'nama_pelanggan': namaPelanggan,
      'jenis_pengaduan': jenisPengaduan,
      'link_url': linkUrl,
      'tanggal_pengaduan': tanggalPengaduan.toIso8601String(),
    };
  }
}
