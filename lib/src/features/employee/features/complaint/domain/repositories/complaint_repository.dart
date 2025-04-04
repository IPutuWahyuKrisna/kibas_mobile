import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failure.dart';
import '../entities/complaint_entity.dart';

abstract class ComplaintRepositoryDomain {
  Future<Either<Failure, List<Complaint>>> getAllComplaints(String token);
  Future<Either<Failure, Complaint>> getComplaintDetail(String token, int id);
}
