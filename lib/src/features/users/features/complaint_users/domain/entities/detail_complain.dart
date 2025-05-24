class DetailComplaintUsers {
  final int id;
  final int pelangganId;
  final String namaPelanggan;
  final String? linkUrl;
  final String status;
  final int? rating;
  final DateTime? tanggalPengaduan;
  final String tanggalSelesai;
  final String keteranganSelesai;
  final String jenisPengaduan;
  final String namaPegawai;
  final String buktiFotoSelesai;

  DetailComplaintUsers({
    required this.id,
    required this.pelangganId,
    required this.namaPelanggan,
    this.linkUrl,
    required this.status,
    this.rating,
    this.tanggalPengaduan,
    required this.tanggalSelesai,
    required this.keteranganSelesai,
    required this.jenisPengaduan,
    required this.namaPegawai,
    required this.buktiFotoSelesai,
  });
}
