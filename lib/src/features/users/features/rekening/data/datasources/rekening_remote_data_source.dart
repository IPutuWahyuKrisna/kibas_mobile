import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:kibas_mobile/src/core/constant/apis.dart';
import 'package:kibas_mobile/src/features/users/features/rekening/data/models/tagihan_model.dart';
import '../../../../../../core/error/exceptions.dart';
import '../../../../../../core/error/failure.dart';
import '../../../../../../core/services/global_service_locator.dart';
import '../../../../../../core/utils/user_local_storage_service.dart';
import '../models/rekening_detail_model.dart';
import '../models/rekening_model.dart';

abstract class RekeningRemoteDataSource {
  Future<List<RekeningModel>> getRekening(int pelangganId);
  Future<RekeningDetailModel> getRekeningDetail(int rekeningId);
  Future<RekeningModel> postRekening(Map<String, dynamic> data);
  Future<RekeningModel> putRekening(Map<String, dynamic> data);
  Future<Either<Failure, List<Map<String, dynamic>>>> getGolonganList();
  Future<Either<Failure, List<Map<String, dynamic>>>> getKecamatanList();
  Future<Either<Failure, List<Map<String, dynamic>>>> getKelurahanList();
  Future<Either<Failure, List<Map<String, dynamic>>>> getAreaList();
  Future<Either<Failure, List<Map<String, dynamic>>>> getRayonList();
  Future<List<TagihanModel>> getTagihan();
}

class RekeningRemoteDataSourceImpl implements RekeningRemoteDataSource {
  final Dio dio;

  RekeningRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<RekeningModel>> getRekening(int pelangganId) async {
    final userService = coreInjection<UserLocalStorageService>();
    final user = userService.getUser();
    final token = user?.token ?? "";
    // final idUsers = user!.pelanggan?.id ?? "";
    // final email = user.email;
    // final role = user.role;
    final response = await dio.get(
        "https://kibas.tirtadanuarta.com/api/v1/rekening?pelanggan_id=$pelangganId",
        options: Options(headers: {'Authorization': 'Bearer $token'}));

    if (response.statusCode == 200) {
      final data = List<Map<String, dynamic>>.from(response.data['data']);

      return data.map((json) => RekeningModel.fromJson(json)).toList();
    } else {
      throw Exception("Gagal mengambil data rekening");
    }
  }

  @override
  Future<RekeningDetailModel> getRekeningDetail(int rekeningId) async {
    final userService = coreInjection<UserLocalStorageService>();
    final user = userService.getUser();
    final token = user?.token ?? "";
    final response = await dio.get(
        "${ApiUrls.detailRekening}$rekeningId/detail",
        options: Options(headers: {'Authorization': 'Bearer $token'}));

    if (response.statusCode == 200) {
      return RekeningDetailModel.fromJson(response.data['data']);
    } else {
      throw Exception("Gagal mengambil detail rekening");
    }
  }

  @override
  Future<List<TagihanModel>> getTagihan() async {
    try {
      final userService = coreInjection<UserLocalStorageService>();
      final user = userService.getUser();
      final token = user?.token ?? "";
      final response = await dio.get(ApiUrls.getTagihan,
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((e) => TagihanModel.fromJson(e)).toList();
      } else {
        throw const ServerException("Gagal mengambil data tagihan");
      }
    } catch (e) {
      throw ServerException("Gagal terhubung ke server: $e");
    }
  }

  @override
  Future<RekeningModel> postRekening(Map<String, dynamic> data) async {
    try {
      final userService = coreInjection<UserLocalStorageService>();
      final user = userService.getUser();
      final token = user?.token ?? "";

      final response = await dio.post(
        ApiUrls.postRekening,
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 201) {
        return RekeningModel.fromJson(response.data['data']);
      } else {
        throw Exception("Gagal menambahkan rekening: ${response.statusCode}");
      }
    } on DioException {
      throw Exception("Terjadi kesalahan saat menambahkan rekening");
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

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getRayonList() async {
    return _fetchDropdownData(ApiUrls.getRayon);
  }

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

  @override
  Future<RekeningModel> putRekening(Map<String, dynamic> data) async {
    try {
      final userService = coreInjection<UserLocalStorageService>();
      final user = userService.getUser();
      final token = user?.token ?? "";
      // Misal endpoint PUT-nya:
      final response = await dio.put(
        "https://kibas.tirtadanuarta.com/api/v1/rekening/${data['id']}/update", // jika ID diperlukan di URL
        data: {
          "pelanggan_id": data['pelanggan_id'],
          "no_rekening": data['no_rekening'],
          "area_id": data['area_id'],
          "kecamatan_id": data['kecamatan_id'],
          "kelurahan_id": data['kelurahan_id'],
          "golongan_id": data['golongan_id'],
          "rayon_id": data['rayon_id'],
          "lat": data['lat'],
          "lng": data['lng'],
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return RekeningModel.fromJson(response.data['data']);
      } else {
        throw Exception("Gagal memperbarui rekening");
      }
    } on DioException {
      throw Exception("Terjadi kesalahan saat memperbarui rekening");
    }
  }
}
