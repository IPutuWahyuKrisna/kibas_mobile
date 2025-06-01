import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../../../core/error/exceptions.dart';
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
    try {
      final response =
          await dio.get('/complaint-employee'); // ganti sesuai endpoint

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
