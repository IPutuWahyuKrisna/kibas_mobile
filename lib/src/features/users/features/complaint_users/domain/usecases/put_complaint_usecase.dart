import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failure.dart';
import '../../data/models/put_complaint_model.dart';
import '../repositories/complaint_users_repository.dart';

class PutComplaintUseCase {
  final ComplaintRepositoryDomainUsers repository;

  PutComplaintUseCase(this.repository);

  Future<Either<Failure, String>> execute(PutComplaintModel complaint) {
    return repository.putComplaint(complaint);
  }
}
