import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:kibas_mobile/src/features/users/features/read%20meter/data/datasources/read_meter_remote_data_source.dart';
import '../../../../../../core/error/exceptions.dart';
import '../../../../../../core/error/failure.dart';
import '../../domain/entities/read_meter.dart';
import '../../domain/repositories/read_meter_repository.dart';

class ReadMeterRepositoryImpl implements MeterRepositoryDomain {
  final ReadMeterRemoteDataSource remoteDataSource;

  ReadMeterRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ReadMeterEntity>>> fetchReadMeter() async {
    try {
      final result = await remoteDataSource.fetchReadMeter();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> postMeter({
    required File linkFoto,
    required String angkaFinal,
  }) async {
    try {
      final result = await remoteDataSource.postMeter(
        linkFoto: linkFoto,
        angkaFinal: angkaFinal,
      );
      return result;
    } on ServerException {
      return const Left(ServerFailure(
          message: "Gagal menghubungi server! Silakan coba lagi nanti."));
    } on NetworkException {
      return const Left(NetworkFailure(
          message: "Tidak ada koneksi internet. Periksa jaringan Anda!"));
    } on ImageProcessingFailure {
      return const Left(ImageProcessingFailure(
          message:
              "Gagal memproses gambar! Pastikan format dan ukuran sesuai."));
    } on UnknownException {
      return const Left(
          UnknownFailure(message: "Terjadi kesalahan yang tidak diketahui!"));
    } catch (e) {
      return const Left(UnknownFailure(
          message:
              "Terjadi kesalahan yang tidak terduga! Silakan coba lagi nanti."));
    }
  }
}
