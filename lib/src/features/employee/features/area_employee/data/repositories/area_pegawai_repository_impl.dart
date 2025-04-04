import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../../core/error/failure.dart';
import '../../domain/entities/area_pegawai_entity.dart';
import '../../domain/repositories/area_pegawai_repository.dart';
import '../datasources/area_pegawai_remote_data_source.dart';

class AreaPegawaiRepositoryImpl implements AreaPegawaiRepositoryDomain {
  final AreaPegawaiRemoteDataSource remoteDataSource;

  AreaPegawaiRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, AreaPegawai>> getAreaPegawai(String token) async {
    try {
      // 🟢 Langsung panggil API get area pegawai dengan token dari parameter
      final areaPegawai = await remoteDataSource.getAreaPegawai(token);
      // 🟢 Log untuk cek data
      return Right(areaPegawai); // 🟢 Kembalikan data area pegawai
    } on DioException catch (e) {
      return Left(
          ServerFailure(message: e.message ?? "Terjadi kesalahan pada server"));
    } catch (e) {
      return const Left(
          UnknownFailure(message: "Terjadi kesalahan yang tidak diketahui"));
    }
  }
}
