import 'package:dio/dio.dart';
import '../../../../../../core/constant/apis.dart';
import '../../../../../../core/error/exceptions.dart';
import '../../../../../../core/services/global_service_locator.dart';
import '../../../../../../core/utils/user_local_storage_service.dart';
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
    final userService = coreInjection<UserLocalStorageService>();
    final user = userService.getUser();
    final tokenUser = user?.token ?? "";
    try {
      final response = await dio.get(
        ApiUrls.getAllPengumuman,
        options: Options(
          headers: {
            'Authorization': 'Bearer $tokenUser',
          },
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(response);
        final data = List<Map<String, dynamic>>.from(response.data['data']);
        return data.map((json) => AnnouncementModel.fromJson(json)).toList();
      } else {
        throw ServerException.fromDioError(DioException(
          response: response,
          type: DioExceptionType.badResponse,
          requestOptions: response.requestOptions,
        ));
      }
    } catch (e) {
      throw UnknownException("Terjadi kesalahan yang tidak diketahui");
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
      throw UnknownException("Terjadi kesalahan yang tidak diketahui");
    }
  }
}
