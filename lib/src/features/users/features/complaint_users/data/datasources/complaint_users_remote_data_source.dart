import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:kibas_mobile/src/core/constant/apis.dart';
import 'package:kibas_mobile/src/features/users/features/complaint_users/data/models/complain_detail_model.dart';
import '../../../../../../core/error/exceptions.dart';
import '../../../../../../core/error/failure.dart';
import '../../../../../../core/services/global_service_locator.dart';
import '../../../../../../core/services/image_compression_service.dart';
import '../../../../../../core/utils/user_local_storage_service.dart';
import '../../domain/entities/detail_complain.dart';
import '../models/complaint_usres_model.dart';
import '../models/post_complaint_model.dart';
import '../models/put_complaint_model.dart';

abstract class ComplaintUsersRemoteDataSource {
  Future<List<ComplaintModelUsers>> getAllComplaintsUsers(String token);
  Future<DetailComplaintUsers> getComplaintDetailUsers(String token, int id);
  Future<Either<Failure, String>> postComplaint(PostComplaintModel complaint);
  Future<String> deleteComplaint(int id);
  Future<Either<Failure, String>> putComplaint(PutComplaintModel complaint);
}

class ComplaintUsersRemoteDataSourceImpl
    implements ComplaintUsersRemoteDataSource {
  final Dio dio;
  final ImageProcessor compressionService;

  ComplaintUsersRemoteDataSourceImpl(this.dio, this.compressionService);

  @override
  Future<List<ComplaintModelUsers>> getAllComplaintsUsers(String token) async {
    final response = await dio.get(
      ApiUrls.getAllPengaduan,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.statusCode == 200) {
      final data = List<Map<String, dynamic>>.from(response.data['data']);
      return data.map((json) => ComplaintModelUsers.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data pengaduan!');
    }
  }

  @override
  Future<DetailComplaintUsers> getComplaintDetailUsers(
      String token, int id) async {
    final response = await dio.get(
      "${ApiUrls.getPengaduanDetail}/$id/detail",
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200) {
      return DetailComplaintModelUsers.fromJson(response.data['data']);
    } else {
      throw Exception('Gagal mengambil detail pengaduan!');
    }
  }

  @override
  Future<Either<Failure, String>> postComplaint(
      PostComplaintModel complaint) async {
    final userService = coreInjection<UserLocalStorageService>();
    final user = userService.getUser();
    final id = user?.pelanggan?.id ?? "";
    final token = user?.token ?? "";

    try {
      final compressedFile =
          await compressionService.compressImage(complaint.image);
      if (compressedFile == null) {
        return const Left(ImageProcessingFailure(
          message:
              "Gagal mengompresi gambar! Pastikan ukuran gambar di bawah 2MB.",
        ));
      }

      final formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(compressedFile.path),
        "complaint": complaint.complaint,
        "pelanggan_id": id,
        "latitude": complaint.latitude,
        "longitude": complaint.longitude,
        "angkafinal": complaint.jenisPengaduan,
      });

      final response = await dio.post(
        ApiUrls.postPengaduan,
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
      return const Left(ServerFailure(message: "Terjadi kesalahan"));
    }
  }

  @override
  Future<String> deleteComplaint(int id) async {
    final userService = coreInjection<UserLocalStorageService>();
    final user = userService.getUser();
    final token = user?.token ?? "";
    try {
      final response = await dio.delete('${ApiUrls.deleteComplaint}$id',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        return response.data['message'];
      } else {
        throw ServerException(response.data['message']);
      }
    } catch (e) {
      throw ServerException("Terjadi kesalahan saat menghapus pengaduan");
    }
  }

  @override
  Future<Either<Failure, String>> putComplaint(
      PutComplaintModel complaint) async {
    try {
      // Ambil token dan pelanggan_id dari Local Storage
      final userService = coreInjection<UserLocalStorageService>();
      final user = userService.getUser();
      final token = user?.token ?? "";
      print(
        "ini isi datanya : ${complaint.pengaduanId}, ${complaint.rating}",
      );
      final response = await dio.post(
        ApiUrls.putPengaduan,
        data: {
          "pengaduan_id": complaint.pengaduanId,
          "rating": complaint.rating
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      if (response.statusCode == 200) {
        return Right(
            response.data['message'] ?? "Pengaduan berhasil diperbarui.");
      } else {
        return Left(ServerFailure(
            message:
                response.data['message'] ?? "Gagal memperbarui pengaduan!"));
      }
    } on DioException catch (e) {
      return Left(ServerFailure(
          message:
              "Terjadi kesalahan: ${e.response?.data['message'] ?? "Gagal memperbarui pengaduan!"}"));
    }
  }
}
