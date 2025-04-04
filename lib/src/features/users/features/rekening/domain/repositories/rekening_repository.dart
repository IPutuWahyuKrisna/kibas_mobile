import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failure.dart';
import '../entities/rekening_detail_entity.dart';
import '../entities/rekening_entity.dart';

abstract class RekeningRepository {
  Future<Either<Failure, List<RekeningEntity>>> getRekening(int pelangganId);
  Future<Either<Failure, RekeningDetailEntity>> getRekeningDetail(
      int rekeningId);
  Future<Either<Failure, RekeningEntity>> postRekening(
      Map<String, dynamic> data);
  Future<Either<Failure, RekeningEntity>> putRekening(
      Map<String, dynamic> data);
  Future<Either<Failure, List<Map<String, dynamic>>>> getGolonganList();
  Future<Either<Failure, List<Map<String, dynamic>>>> getKecamatanList();
  Future<Either<Failure, List<Map<String, dynamic>>>> getKelurahanList();
  Future<Either<Failure, List<Map<String, dynamic>>>> getAreaList();
  Future<Either<Failure, List<Map<String, dynamic>>>> getRayonList();
}
