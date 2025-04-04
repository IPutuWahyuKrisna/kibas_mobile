import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failure.dart';
import '../entities/complaint_users_entity.dart';
import '../repositories/complaint_users_repository.dart';

class GetComplaintDetailUsersUseCase {
  final ComplaintRepositoryDomainUsers repository;

  GetComplaintDetailUsersUseCase(this.repository);

  Future<Either<Failure, ComplaintUsers>> call(String token, int id) {
    return repository.getComplaintDetailUsers(token, id);
  }
}
