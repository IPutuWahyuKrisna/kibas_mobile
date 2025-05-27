import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:kibas_mobile/src/core/constant/apis.dart';
import '../../../../../../core/error/exceptions.dart';
import '../../../../../../core/error/failure.dart';
import '../../../../../../core/services/global_service_locator.dart';
import '../../../../../../core/services/image_compression_service.dart';
import '../../../../../../core/utils/user_local_storage_service.dart';
import '../models/read_meter_model.dart';

abstract class ReadMeterRemoteDataSource {
  Future<List<ReadMeterModel>> fetchReadMeter();
  Future<Either<Failure, String>> postMeter({
    required File linkFoto,
    required String angkaFinal,
  });
}

class ReadMeterRemoteDataSourceImpl implements ReadMeterRemoteDataSource {
  final Dio dio;
  final ImageProcessor compressionService;

  ReadMeterRemoteDataSourceImpl(this.dio, this.compressionService);

  /// 🔹 GET: Fetch Data Read Meter
  @override
  Future<List<ReadMeterModel>> fetchReadMeter() async {
    try {
      final userService = coreInjection<UserLocalStorageService>();
      final user = userService.getUser();
      final token = user?.token ?? "";
      final response = await dio.get(
        ApiUrls.getReadMeter,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => ReadMeterModel.fromJson(json)).toList();
      } else {
        throw ServerException("Gagal mengambil data baca meter!");
      }
    } catch (e) {
      throw UnknownException("Terjadi kesalahan tidak terduga.");
    }
  }

  /// 🔹 POST: Submit Post Meter Data
  @override
  Future<Either<Failure, String>> postMeter({
    required File linkFoto,
    required String angkaFinal,
  }) async {
    final userService = coreInjection<UserLocalStorageService>();
    final user = userService.getUser();
    final token = user?.token ?? "";

    final compressedFile = await compressionService.compressImage(linkFoto);
    if (compressedFile == null) {
      return const Left(ImageProcessingFailure(
          message:
              "Gagal mengompresi gambar! Pastikan ukuran gambar di bawah 2MB."));
    }

    final formData = FormData.fromMap({
      "link_foto": await MultipartFile.fromFile(compressedFile.path),
      "angka_final": angkaFinal
    });

    final response = await dio.post(
      ApiUrls.postReadMeter,
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        },
        sendTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    if (response.statusCode == 201) {
      return const Right("Data meter berhasil dikirim!");
    } else if (response.statusCode == 422) {
      return const Left(
          ServerFailure(message: "Anda sudah melakukan baca meter bulan ini."));
    } else {
      return const Left(ServerFailure(
          message: "Gagal mengirim data meter! Coba lagi nanti."));
    }
  }
}
