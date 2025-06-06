// complaint_remote_data_source.dart
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:kibas_mobile/src/core/constant/apis.dart';
import '../../../../../../core/error/exceptions.dart';
import '../../../../../../core/error/failure.dart';
import '../../../../../../core/services/global_service_locator.dart';
import '../../../../../../core/services/image_compression_service.dart';
import '../../../../../../core/utils/user_local_storage_service.dart';
import '../../domain/entities/complaint_entity.dart';
import '../models/post_complaint_employee.dart';

abstract class ComplaintRemoteDataSource {
  Future<List<ComplaintEmployee>> getComplaints();
  Future<Either<Failure, String>> postComplaint(ComplaintCompletion complaint);
}

class ComplaintRemoteDataSourceImpl implements ComplaintRemoteDataSource {
  final Dio dio;
  final ImageProcessor compressionService;

  ComplaintRemoteDataSourceImpl(
      {required this.dio, required this.compressionService});

  @override
  Future<List<ComplaintEmployee>> getComplaints() async {
    final userService = coreInjection<UserLocalStorageService>();
    final user = userService.getUser();
    final token = user?.token ?? "";
    try {
      final response = await dio.get(
        ApiUrls.getPengaduanPegawai,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.data['status'] != 'success') {
        throw ServerException(
            response.data['message'] ?? 'Gagal mengambil data complaint');
      }

      return (response.data['data'] as List)
          .map((e) => ComplaintEmployee.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw ServerException.fromDioError(e);
    } catch (e) {
      throw const ServerException(
          'Terjadi kesalahan saat mengambil data pengaduan');
    }
  }

  @override
  Future<Either<Failure, String>> postComplaint(
      ComplaintCompletion complaint) async {
    final userService = coreInjection<UserLocalStorageService>();
    final user = userService.getUser();
    final token = user?.token ?? "";
    try {
      final compressedFile =
          await compressionService.compressImage(complaint.buktiFotoSelesai);
      if (compressedFile == null) {
        return const Left(ImageProcessingFailure(
          message:
              "Gagal mengompresi gambar! Pastikan ukuran gambar di bawah 2MB.",
        ));
      }
      print(complaint.pengaduanId);
      final formData = FormData.fromMap({
        'pengaduan_id': "${complaint.pengaduanId}",
        'catatan': complaint.catatan,
        'bukti_foto_selesai': await MultipartFile.fromFile(compressedFile.path),
      });

      final response = await dio.post(
        ApiUrls.putPengaduanPegawai,
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

      if (response.statusCode == 200) {
        return Right(response.data["message"]);
      } else if (response.statusCode == 400) {
        return const Left(
            ServerFailure(message: "Data tidak valid! Periksa input Anda."));
      } else if (response.statusCode == 500) {
        return const Left(ServerFailure(
            message: "Kesalahan server! Silakan coba lagi nanti."));
      } else {
        return const Left(ServerFailure(message: "Gagal mengirim pengaduan!"));
      }
    } catch (e) {
      print(e);
      return const Left(ServerFailure(message: "Terjadi kesalahan"));
    }
  }
}
