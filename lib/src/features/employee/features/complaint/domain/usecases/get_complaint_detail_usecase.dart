import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failure.dart';
import '../entities/complaint_entity.dart';
import '../repositories/complaint_repository.dart';

class GetComplaintDetailUseCase {
  final ComplaintRepositoryDomain repository;

  GetComplaintDetailUseCase(this.repository);

  Future<Either<Failure, Complaint>> call(String token, int id) {
    return repository.getComplaintDetail(token, id);
  }
}
