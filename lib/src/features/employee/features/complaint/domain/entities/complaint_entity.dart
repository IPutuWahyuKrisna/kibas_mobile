class Complaint {
  final int id;
  final String keluhan;
  final String linkFoto;
  final int status;
  final int pelangganId;
  final String namaPelanggan;
  final String? createdAt;

  Complaint({
    required this.id,
    required this.keluhan,
    required this.linkFoto,
    required this.status,
    required this.pelangganId,
    required this.namaPelanggan,
    this.createdAt,
  });
}
