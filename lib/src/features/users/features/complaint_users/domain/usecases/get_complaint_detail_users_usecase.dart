import 'package:dartz/dartz.dart';
import 'package:kibas_mobile/src/features/users/features/complaint_users/domain/entities/detail_complain.dart';
import '../../../../../../core/error/failure.dart';
import '../repositories/complaint_users_repository.dart';

class GetComplaintDetailUsersUseCase {
  final ComplaintRepositoryDomainUsers repository;

  GetComplaintDetailUsersUseCase(this.repository);

  Future<Either<Failure, DetailComplaintUsers>> call(String token, int id) {
    return repository.getComplaintDetailUsers(token, id);
  }
}
