class Announcement {
  final int id;
  final String judul;
  final String content;
  final String linkFoto;
  final String tanggalMulai;
  final String tanggalBerakhir;
  final String targetScope;

  Announcement({
    required this.id,
    required this.judul,
    required this.content,
    required this.linkFoto,
    required this.tanggalMulai,
    required this.tanggalBerakhir,
    required this.targetScope,
  });
}
