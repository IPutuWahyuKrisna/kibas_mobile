class ComplaintUsers {
  final int id;
  final int pelangganId;
  final String? linkUrl;
  final double pengaduanLat;
  final double pengaduanLong;
  final String status;
  final int? rating;
  final DateTime tanggalPengaduan;
  final DateTime? tanggalSelesai;
  final String? keteranganSelesai;
  final String jenisPengaduan;

  const ComplaintUsers({
    required this.id,
    required this.pelangganId,
    this.linkUrl,
    required this.pengaduanLat,
    required this.pengaduanLong,
    required this.status,
    this.rating,
    required this.tanggalPengaduan,
    this.tanggalSelesai,
    this.keteranganSelesai,
    required this.jenisPengaduan,
  });
}
