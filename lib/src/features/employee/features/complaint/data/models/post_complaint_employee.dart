import 'dart:io';

class ComplaintCompletion {
  final int pengaduanId;
  final File buktiFotoSelesai;
  final String catatan;

  ComplaintCompletion({
    required this.pengaduanId,
    required this.buktiFotoSelesai,
    required this.catatan,
  });

  // Untuk kirim sebagai multipart/form-data
  Map<String, dynamic> toJson() {
    return {
      'pengaduan_id': pengaduanId.toString(),
      'catatan': catatan,
    };
  }
}
