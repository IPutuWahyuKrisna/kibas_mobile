import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:kibas_mobile/src/core/constant/apis.dart';
import 'package:kibas_mobile/src/features/users/features/dashboard_user/data/models/edit_user.dart';
import '../../../../../../core/error/failure.dart';
import '../../../../../../core/services/global_service_locator.dart';
import '../../../../../../core/utils/user_local_storage_service.dart';

abstract class PutRemoteDataSource {
  Future<Either<Failure, String>> putUser(EditUserModel putUser);
  Future<Either<Failure, List<Map<String, dynamic>>>> getGolonganList();
  Future<Either<Failure, List<Map<String, dynamic>>>> getKecamatanList();
  Future<Either<Failure, List<Map<String, dynamic>>>> getKelurahanList();
  Future<Either<Failure, List<Map<String, dynamic>>>> getAreaList();
}

class PutRemoteDataSourceImpl implements PutRemoteDataSource {
  final Dio dio;

  PutRemoteDataSourceImpl(this.dio);

  @override
  Future<Either<Failure, String>> putUser(EditUserModel putUser) async {
    final userService = coreInjection<UserLocalStorageService>();
    final user = userService.getUser();
    final token = user?.token ?? "";
    try {
      final response = await dio.put(ApiUrls.putUsers,
          data: putUser.toJson(),
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200) {
        return const Right("Edit data user berhasil!");
      } else {
        return const Left(ServerFailure(message: "Gagal melakukan edit user."));
      }
    } on DioException catch (e) {
      return Left(
          ServerFailure(message: e.message ?? "Terjadi kesalahan di server."));
    }
  }

  /// 🔹 Fetch Golongan List
  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getGolonganList() async {
    return _fetchDropdownData(ApiUrls.getGolongan);
  }

  /// 🔹 Fetch Kecamatan List
  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getKecamatanList() async {
    return _fetchDropdownData(ApiUrls.getKecamata);
  }

  /// 🔹 Fetch Kelurahan List
  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getKelurahanList() async {
    return _fetchDropdownData(ApiUrls.getKelurahan);
  }

  /// 🔹 Fetch Area List
  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getAreaList() async {
    return _fetchDropdownData(ApiUrls.getAreaRegist);
  }

  /// 🔹 Helper Method untuk Fetch Data Dropdown
  Future<Either<Failure, List<Map<String, dynamic>>>> _fetchDropdownData(
      String url) async {
    try {
      final response = await dio.get(url);

      if (response.statusCode == 200 && response.data['data'] != null) {
        List<Map<String, dynamic>> dataList =
            List<Map<String, dynamic>>.from(response.data['data']);
        return Right(dataList);
      } else {
        return const Left(ServerFailure(message: "Gagal mengambil data."));
      }
    } on DioException {
      return const Left(
          ServerFailure(message: "Terjadi kesalahan yang tidak terduga"));
    }
  }
}
