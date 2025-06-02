// fetch_complaint_employee_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failure.dart';
import '../entities/complaint_entity.dart';
import '../repositories/complaint_repository.dart';

class FetchComplaintEmployeeUseCase {
  final ComplaintEmployeeRepository repository;

  FetchComplaintEmployeeUseCase(this.repository);

  Future<Either<Failure, List<ComplaintEmployee>>> call() {
    return repository.fetchComplaintList();
  }
}
