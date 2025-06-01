import 'package:dartz/dartz.dart';
import '../entities/complaint_entity.dart';

abstract class ComplaintEmployeeRepository {
  Future<List<ComplaintEmployeeEntity>> getAllComplaintEmployee();
}
