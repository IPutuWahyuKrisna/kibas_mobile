import '../entities/complaint_entity.dart';

abstract class ComplaintEmployeeRepository {
  Future<List<ComplaintEmployeeEntity>> getAllComplaintEmployee();
}
