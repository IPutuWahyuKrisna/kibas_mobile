class Area {
  final int id;
  final int kecamatanId;
  final String namaArea;
  final Kecamatan kecamatan;

  Area({
    required this.id,
    required this.kecamatanId,
    required this.namaArea,
    required this.kecamatan,
  });
}

class Kecamatan {
  final int id;
  final String kecamatan;

  Kecamatan({
    required this.id,
    required this.kecamatan,
  });
}
