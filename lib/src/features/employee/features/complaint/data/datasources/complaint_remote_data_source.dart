import 'package:dio/dio.dart';
import 'package:kibas_mobile/src/core/constant/apis.dart';
import '../models/complaint_model.dart';

abstract class ComplaintRemoteDataSource {
  Future<List<ComplaintModel>> getAllComplaints(String token);
  Future<ComplaintModel> getComplaintDetail(String token, int id);
}

class ComplaintRemoteDataSourceImpl implements ComplaintRemoteDataSource {
  final Dio dio;

  ComplaintRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ComplaintModel>> getAllComplaints(String token) async {
    final response = await dio.get(
      ApiUrls.complaint,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 200) {
      final data = List<Map<String, dynamic>>.from(response.data['data']);
      return data.map((json) => ComplaintModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data pengaduan!');
    }
  }

  @override
  Future<ComplaintModel> getComplaintDetail(String token, int id) async {
    final response = await dio.get(
      "https://kibas.tirtadanuarta.com/api/v1/pengaduan/$id",
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 200) {
      return ComplaintModel.fromJson(response.data['data']);
    } else {
      throw Exception('Gagal mengambil detail pengaduan!');
    }
  }
}
