import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failure.dart';
import '../../data/models/put_complaint_model.dart';
import '../entities/complaint_users_entity.dart';

abstract class ComplaintRepositoryDomainUsers {
  Future<Either<Failure, List<ComplaintUsers>>> getAllComplaintsUsers(
      String token);
  Future<Either<Failure, ComplaintUsers>> getComplaintDetailUsers(
      String token, int id);
  Future<Either<Failure, String>> postComplaint({
    required File image,
    required String complaint,
  });
  Future<Either<Failure, String>> deleteComplaint(int id);
  Future<Either<Failure, String>> putComplaint(PutComplaintModel complaint);
}
