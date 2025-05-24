class ReadMeterEntity {
  final int id;
  final String linkFoto;
  final String status;
  final String angkaFinal;
  final String? keterangan;
  final String createdAt;

  const ReadMeterEntity({
    required this.id,
    required this.linkFoto,
    required this.status,
    required this.angkaFinal,
    required this.keterangan,
    required this.createdAt,
  });
}
