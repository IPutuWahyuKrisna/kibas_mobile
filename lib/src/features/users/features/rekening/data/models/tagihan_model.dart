import '../../domain/entities/detail_Tagihan.dart';
import '../../domain/entities/tagihan.dart';

class TagihanModel extends TagihanEntity {
  const TagihanModel({
    required super.tagihanId,
    required super.periode,
    required super.namaPelanggan,
    required super.alamat,
    required super.noSambungan,
    required super.totalTagihan,
    required super.denda,
    required super.status,
    required super.statusBadge,
    required super.periodeRaw,
    required super.createdAt,
    required super.updatedAt,
    required super.detail,
  });

  factory TagihanModel.fromJson(Map<String, dynamic> json) {
    return TagihanModel(
      tagihanId: json['tagihan_id'],
      periode: json['periode'],
      namaPelanggan: json['nama_pelanggan'],
      alamat: json['alamat'],
      noSambungan: json['no_sambungan'],
      totalTagihan: json['total_tagihan'],
      denda: json['denda'],
      status: json['status'],
      statusBadge: json['status_badge'],
      periodeRaw: json['periode_raw'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      detail: DetailTagihanModel.fromJson(json['detail']),
    );
  }
}

class DetailTagihanModel extends DetailTagihanEntity {
  const DetailTagihanModel({
    required super.stanLalu,
    required super.stanSkrg,
    required super.pemakaian,
    required super.biayaAir,
    required super.denda,
    required super.segel,
    required super.sambungKembali,
    required super.totalSebelumDenda,
  });

  factory DetailTagihanModel.fromJson(Map<String, dynamic> json) {
    return DetailTagihanModel(
      stanLalu: json['stanlalu'],
      stanSkrg: json['stanskrg'],
      pemakaian: json['pemakaian'],
      biayaAir: json['biaya_air'],
      denda: json['denda'],
      segel: json['segel'],
      sambungKembali: json['sambung_kembali'],
      totalSebelumDenda: json['total_sebelum_denda'],
    );
  }
}
