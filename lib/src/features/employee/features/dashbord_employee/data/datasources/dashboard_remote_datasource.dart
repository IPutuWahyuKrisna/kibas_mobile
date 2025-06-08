import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../../core/constant/apis.dart';
import '../../../../../../core/error/exceptions.dart';
import '../../../../../../core/error/failure.dart';
import '../models/anoouncement_models.dart';
import '../models/logout_models.dart';

abstract class DashboardRemoteDataSource {
  Future<List<AnnouncementModel>> getAllAnnouncements(String token);
  Future<LogoutModel> logout(String token);
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final Dio dio;

  DashboardRemoteDataSourceImpl(this.dio);

  @override
  Future<List<AnnouncementModel>> getAllAnnouncements(String token) async {
    print(token);
    if (token != "") {
      final response = await dio.get(
        ApiUrls.getAllPengumuman,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );
      print(
          "ini response datanya ${response.statusCode} ${response.statusMessage}");
      if (response.statusCode == 200) {
        final data = List<Map<String, dynamic>>.from(response.data['data']);
        return data.map((json) => AnnouncementModel.fromJson(json)).toList();
      }
      if (response.statusCode == 401) {
        print("masuk ke sini njink");
        throw const Left(
          ServerFailure(
            message:
                "Perangkat lain telah masuk menggunakan akun anda, silakan login kembali.",
          ),
        );
      } else {
        print("sini");
        throw ServerException.fromDioError(DioException(
          response: response,
          type: DioExceptionType.badResponse,
          requestOptions: response.requestOptions,
        ));
      }
    } else {
      print("masuk ke sini");
      throw const ServerException("tidak ada data");
    }
  }

  @override
  Future<LogoutModel> logout(String token) async {
    try {
      final response = await dio.post(
        "ApiUrls.logOut",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      if (response.statusCode == 200) {
        return LogoutModel.fromJson(response.data);
      } else {
        throw ServerException.fromDioError(DioException(
          response: response,
          type: DioExceptionType.badResponse,
          requestOptions: response.requestOptions,
        ));
      }
    } catch (e) {
      throw const UnknownException("Terjadi kesalahan yang tidak diketahui");
    }
  }
}
