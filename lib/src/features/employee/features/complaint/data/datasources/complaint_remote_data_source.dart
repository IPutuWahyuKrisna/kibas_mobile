import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../../../core/constant/apis.dart';
import '../../../../../../core/error/exceptions.dart';
import '../../../../../../core/services/global_service_locator.dart';
import '../../../../../../core/utils/user_local_storage_service.dart';
import '../models/complaint_model.dart';

abstract class ComplaintEmployeeRemoteDataSource {
  Future<List<ComplaintEmployeeModel>> getAllComplaintEmployee();
}

class ComplaintEmployeeRemoteDataSourceImpl
    implements ComplaintEmployeeRemoteDataSource {
  final Dio dio;
  final GetStorage storage;

  ComplaintEmployeeRemoteDataSourceImpl(
      {required this.dio, required this.storage});

  @override
  Future<List<ComplaintEmployeeModel>> getAllComplaintEmployee() async {
    final userService = coreInjection<UserLocalStorageService>();
    final user = userService.getUser();
    final token = user?.token ?? "";
    try {
      final response = await dio.get(ApiUrls.getPengaduanPegawai,
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
            sendTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
          ));

      final data = response.data['data'] as List;

      return data.map((e) => ComplaintEmployeeModel.fromJson(e)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await storage.remove('user');
      }
      throw ServerException.fromDioError(e);
    }
  }
}
