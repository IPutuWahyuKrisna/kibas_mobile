import 'package:equatable/equatable.dart';

class ComplaintEmployeeEntity extends Equatable {
  final int id;
  final int pengaduanId;
  final String namaPelanggan;
  final String jenisPengaduan;
  final String linkUrl;
  final DateTime tanggalPengaduan;

  const ComplaintEmployeeEntity({
    required this.id,
    required this.pengaduanId,
    required this.namaPelanggan,
    required this.jenisPengaduan,
    required this.linkUrl,
    required this.tanggalPengaduan,
  });

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
