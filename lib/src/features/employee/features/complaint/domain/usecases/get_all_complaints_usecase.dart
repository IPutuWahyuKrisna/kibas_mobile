import '../entities/complaint_entity.dart';
import '../repositories/complaint_repository.dart';

class GetAllComplaintEmployeeUseCase {
  final ComplaintEmployeeRepository repository;

  GetAllComplaintEmployeeUseCase(this.repository);

  Future<List<ComplaintEmployeeEntity>> call() {
    return repository.getAllComplaintEmployee();
  }
}
