import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failure.dart';
import '../repositories/complaint_users_repository.dart';

class PostComplaintUseCase {
  final ComplaintRepositoryDomainUsers repository;

  PostComplaintUseCase(this.repository);

  Future<Either<Failure, String>> execute({
    required File image,
    required String complaint,
  }) {
    return repository.postComplaint(image: image, complaint: complaint);
  }
}
