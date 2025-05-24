class JenisPengaduanModel {
  final int id;
  final String nama;

  JenisPengaduanModel({required this.id, required this.nama});

  factory JenisPengaduanModel.fromJson(Map<String, dynamic> json) {
    return JenisPengaduanModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      nama: json['nama'],
    );
  }
}
