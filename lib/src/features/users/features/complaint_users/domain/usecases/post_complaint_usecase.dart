import 'dart:ffi';
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
    required double latitude,
    required double longitude,
    required int jenisPengaduan,
  }) {
    return repository.postComplaint(
      image: image,
      complaint: complaint,
      latitude: latitude,
      longitude: longitude,
      jenisPengaduan: jenisPengaduan,
    );
  }
}
