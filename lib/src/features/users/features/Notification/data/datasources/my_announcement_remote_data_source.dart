import 'package:dio/dio.dart';
import 'package:kibas_mobile/src/core/constant/apis.dart';
import '../../../../../../core/error/exceptions.dart';
import '../../../../../../core/services/global_service_locator.dart';
import '../../../../../../core/utils/user_local_storage_service.dart';
import '../models/my_announcement_model.dart';

abstract class MyAnnouncementRemoteDataSource {
  Future<List<MyAnnouncementModel>> fetchMyAnnouncements();
}

class MyAnnouncementRemoteDataSourceImpl
    implements MyAnnouncementRemoteDataSource {
  final Dio dio;

  MyAnnouncementRemoteDataSourceImpl(this.dio);

  @override
  Future<List<MyAnnouncementModel>> fetchMyAnnouncements() async {
    final userService = coreInjection<UserLocalStorageService>();
    final user = userService.getUser();
    final token = user?.token ?? "";
    try {
      final response = await dio.get(
        ApiUrls.getMyPengumuman,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      ); // Ganti dengan URL Anda
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((e) => MyAnnouncementModel.fromJson(e)).toList();
      } else {
        throw ServerException("Gagal memuat pengumuman pribadi");
      }
    } catch (e) {
      throw ServerException("Terjadi kesalahan: ${e.toString()}");
    }
  }
}
