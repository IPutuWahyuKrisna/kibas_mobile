import 'package:equatable/equatable.dart';

class DetailTagihanEntity extends Equatable {
  final String stanLalu;
  final String stanSkrg;
  final String pemakaian;
  final String biayaAir;
  final String denda;
  final String segel;
  final String sambungKembali;
  final String totalSebelumDenda;

  const DetailTagihanEntity({
    required this.stanLalu,
    required this.stanSkrg,
    required this.pemakaian,
    required this.biayaAir,
    required this.denda,
    required this.segel,
    required this.sambungKembali,
    required this.totalSebelumDenda,
  });

  @override
  List<Object?> get props => [
        stanLalu,
        stanSkrg,
        pemakaian,
        biayaAir,
        denda,
        segel,
        sambungKembali,
        totalSebelumDenda,
      ];
}
