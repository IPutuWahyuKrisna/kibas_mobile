import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failure.dart';
import '../repositories/complaint_users_repository.dart';

class DeleteComplaintUseCase {
  final ComplaintRepositoryDomainUsers repository;

  DeleteComplaintUseCase(this.repository);

  Future<Either<Failure, String>> execute(int id) async {
    return await repository.deleteComplaint(id);
  }
}
