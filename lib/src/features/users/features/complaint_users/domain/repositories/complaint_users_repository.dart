import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:kibas_mobile/src/features/users/features/complaint_users/domain/entities/detail_complain.dart';
import '../../../../../../core/error/failure.dart';
import '../../data/models/put_complaint_model.dart';
import '../entities/complaint_users_entity.dart';

abstract class ComplaintRepositoryDomainUsers {
  Future<Either<Failure, List<ComplaintUsers>>> getAllComplaintsUsers(
      String token);
  Future<Either<Failure, DetailComplaintUsers>> getComplaintDetailUsers(
      String token, int id);
  Future<Either<Failure, String>> postComplaint({
    required File image,
    required String complaint,
    required double latitude,
    required double longitude,
    required String jenisPengaduan,
  });

  Future<Either<Failure, String>> deleteComplaint(int id);
  Future<Either<Failure, String>> putComplaint(PutComplaintModel complaint);
}
