import '../../domain/entities/complaint_entity.dart';
import '../../domain/repositories/complaint_repository.dart';
import '../datasources/complaint_remote_data_source.dart';

class ComplaintEmployeeRepositoryImpl implements ComplaintEmployeeRepository {
  final ComplaintEmployeeRemoteDataSource remoteDataSource;

  ComplaintEmployeeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ComplaintEmployeeEntity>> getAllComplaintEmployee() async {
    final result = await remoteDataSource.getAllComplaintEmployee();
    return result;
  }
}
