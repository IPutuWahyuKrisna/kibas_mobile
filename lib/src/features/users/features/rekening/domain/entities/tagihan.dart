import 'package:equatable/equatable.dart';
import 'package:kibas_mobile/src/features/users/features/rekening/domain/entities/detail_Tagihan.dart';

class TagihanEntity extends Equatable {
  final int tagihanId;
  final String periode;
  final String namaPelanggan;
  final String alamat;
  final String noSambungan;
  final String totalTagihan;
  final String denda;
  final String status;
  final String statusBadge;
  final String periodeRaw;
  final String createdAt;
  final String updatedAt;
  final DetailTagihanEntity detail;

  const TagihanEntity({
    required this.tagihanId,
    required this.periode,
    required this.namaPelanggan,
    required this.alamat,
    required this.noSambungan,
    required this.totalTagihan,
    required this.denda,
    required this.status,
    required this.statusBadge,
    required this.periodeRaw,
    required this.createdAt,
    required this.updatedAt,
    required this.detail,
  });

  @override
  List<Object?> get props => [
        tagihanId,
        periode,
        namaPelanggan,
        alamat,
        noSambungan,
        totalTagihan,
        denda,
        status,
        statusBadge,
        periodeRaw,
        createdAt,
        updatedAt,
        detail,
      ];
}
