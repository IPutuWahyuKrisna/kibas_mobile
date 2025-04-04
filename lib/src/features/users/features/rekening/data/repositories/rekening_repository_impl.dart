import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failure.dart';
import '../../domain/entities/rekening_detail_entity.dart';
import '../../domain/entities/rekening_entity.dart';
import '../../domain/repositories/rekening_repository.dart';
import '../datasources/rekening_remote_data_source.dart';

class RekeningRepositoryImpl implements RekeningRepository {
  final RekeningRemoteDataSource remoteDataSource;

  RekeningRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<RekeningEntity>>> getRekening(
      int pelangganId) async {
    try {
      final result = await remoteDataSource.getRekening(pelangganId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RekeningDetailEntity>> getRekeningDetail(
      int rekeningId) async {
    try {
      final result = await remoteDataSource.getRekeningDetail(rekeningId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RekeningEntity>> putRekening(
      Map<String, dynamic> data) async {
    try {
      final result = await remoteDataSource.putRekening(data);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RekeningEntity>> postRekening(
      Map<String, dynamic> data) async {
    try {
      final result = await remoteDataSource.postRekening(data);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getGolonganList() {
    return remoteDataSource.getGolonganList();
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getKecamatanList() {
    return remoteDataSource.getKecamatanList();
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getKelurahanList() {
    return remoteDataSource.getKelurahanList();
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getAreaList() {
    return remoteDataSource.getAreaList();
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getRayonList() {
    return remoteDataSource.getRayonList();
  }
}
