import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failure.dart';
import '../entities/complaint_users_entity.dart';
import '../repositories/complaint_users_repository.dart';

class GetAllComplaintsUsersUseCase {
  final ComplaintRepositoryDomainUsers repository;

  GetAllComplaintsUsersUseCase(this.repository);

  Future<Either<Failure, List<ComplaintUsers>>> call(String token) {
    return repository.getAllComplaintsUsers(token);
  }
}
