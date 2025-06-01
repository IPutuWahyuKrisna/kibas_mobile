import 'package:dio/dio.dart';
import '../../../../../../core/constant/apis.dart';
import '../../../../../../core/error/exceptions.dart';
import '../models/area_pegawai_model.dart';

abstract class AreaPegawaiRemoteDataSource {
  Future<AreaPegawaiModel> getAreaPegawai(String token);
}

class AreaPegawaiRemoteDataSourceImpl implements AreaPegawaiRemoteDataSource {
  final Dio dio;

  AreaPegawaiRemoteDataSourceImpl(this.dio);

  @override
  Future<AreaPegawaiModel> getAreaPegawai(String token) async {
    try {
      final response = await dio.get(
        " ApiUrls.getArea", // 🟢 Endpoint untuk get area pegawai
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final data = response.data['data'];
        final firstKey = data.keys.first;
        final areaData = data[firstKey];

        return AreaPegawaiModel.fromJson(areaData);
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
