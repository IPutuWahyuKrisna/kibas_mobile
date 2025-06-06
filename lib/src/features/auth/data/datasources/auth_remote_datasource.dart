import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kibas_mobile/src/core/constant/apis.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/utils/user_local_storage_service.dart';
import '../models/register_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<Either<Failure, String>> register(RegisterModel registerData);
  Future<Either<Failure, List<Map<String, dynamic>>>> getGolonganList();
  Future<Either<Failure, List<Map<String, dynamic>>>> getKecamatanList();
  Future<Either<Failure, List<Map<String, dynamic>>>> getKelurahanList();
  Future<Either<Failure, List<Map<String, dynamic>>>> getAreaList();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      print(fcmToken);
      final response = await dio.post(
        ApiUrls.login,
        data: {'email': email, 'password': password, 'fcm_token': fcmToken},
        options: Options(
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );
      print(response.data["message"]);
      if (response.statusCode == 200) {
        print("berhasil");
        final userModel = UserModel.fromJson(response.data["data"]);
        await authInjec<UserLocalStorageService>().saveUser(userModel);
        authInjec<UserLocalStorageService>().getUser();
        return userModel;
      } else {
        throw ServerException.fromDioError(DioException(
          response: response,
          type: DioExceptionType.badResponse,
          requestOptions: response.requestOptions,
        ));
      }
    } on DioException catch (e) {
      throw ServerException.fromDioError(e);
    } catch (e) {
      throw const UnknownException("Terjadi kesalahan yang tidak diketahui");
    }
  }

  @override
  Future<Either<Failure, String>> register(RegisterModel registerData) async {
    try {
      final response = await dio.post(
        ApiUrls.register,
        data: registerData.toJson(),
        options: Options(
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );
      print(response);
      if (response.statusCode == 404) {
        return const Left(
            ServerFailure(message: "Gagal melakukan registrasi."));
      } else if (response.statusCode == 201) {
        print("berhasil kleng");
        return const Right("Registrasi berhasil!");
      } else {
        return const Left(
            ServerFailure(message: "Gagal melakukan registrasi."));
      }
    } on DioException catch (e) {
      return Left(
          ServerFailure(message: e.message ?? "Terjadi kesalahan di server."));
    } catch (e) {
      throw const UnknownException("Terjadi kesalahan yang tidak diketahui");
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
