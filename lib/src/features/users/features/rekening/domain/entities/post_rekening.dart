class PostRekeningEntity {
  final String noRekening;
  final int pelangganId;
  final int areaId;
  final int kelurahanId;
  final int kecamatanId;
  final int golonganId;
  final int rayonId;
  final String lat;
  final String lng;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PostRekeningEntity({
    required this.noRekening,
    required this.pelangganId,
    required this.areaId,
    required this.kelurahanId,
    required this.kecamatanId,
    required this.golonganId,
    required this.rayonId,
    required this.lat,
    required this.lng,
    this.createdAt,
    this.updatedAt,
  });
}
