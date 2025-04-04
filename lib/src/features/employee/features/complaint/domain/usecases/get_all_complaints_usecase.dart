import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failure.dart';
import '../entities/complaint_entity.dart';
import '../repositories/complaint_repository.dart';

class GetAllComplaintsUseCase {
  final ComplaintRepositoryDomain repository;

  GetAllComplaintsUseCase(this.repository);

  Future<Either<Failure, List<Complaint>>> call(String token) {
    return repository.getAllComplaints(token);
  }
}
