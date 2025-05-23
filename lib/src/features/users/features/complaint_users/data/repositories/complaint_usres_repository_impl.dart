import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:kibas_mobile/src/features/users/features/complaint_users/data/models/put_complaint_model.dart';
import '../../../../../../core/error/failure.dart';
import '../../domain/entities/complaint_users_entity.dart';
import '../../domain/entities/detail_complain.dart';
import '../../domain/repositories/complaint_users_repository.dart';
import '../datasources/complaint_users_remote_data_source.dart';
import '../models/post_complaint_model.dart';

class ComplaintUsersRepositoryImpl implements ComplaintRepositoryDomainUsers {
  final ComplaintUsersRemoteDataSource remoteDataSource;

  ComplaintUsersRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ComplaintUsers>>> getAllComplaintsUsers(
      String token) async {
    try {
      final complaints = await remoteDataSource.getAllComplaintsUsers(token);
      return Right(complaints);
    } catch (e) {
      return const Left(
          ServerFailure(message: 'Gagal mengambil data pengaduan!'));
    }
  }

  @override
  Future<Either<Failure, DetailComplaintUsers>> getComplaintDetailUsers(
      String token, int id) async {
    try {
      final complaint =
          await remoteDataSource.getComplaintDetailUsers(token, id);
      return Right(complaint);
    } catch (e) {
      return const Left(
          ServerFailure(message: 'Gagal mengambil detail pengaduan!'));
    }
  }

  @override
  @override
  Future<Either<Failure, String>> postComplaint({
    required File image,
    required String complaint,
    required double latitude,
    required double longitude,
    required String jenisPengaduan,
  }) async {
    try {
      final model = PostComplaintModel(
        image: image,
        complaint: complaint,
        latitude: latitude,
        longitude: longitude,
        jenisPengaduan: jenisPengaduan,
      );
      return await remoteDataSource.postComplaint(model);
    } catch (_) {
      return const Left(ServerFailure(message: "Gagal memproses pengaduan"));
    }
  }

  @override
  Future<Either<Failure, String>> deleteComplaint(int id) async {
    try {
      final message = await remoteDataSource.deleteComplaint(id);
      return Right(message);
    } catch (e) {
      return const Left(ServerFailure(message: "Gagal menghapus pengaduan"));
    }
  }

  @override
  @override
  Future<Either<Failure, String>> putComplaint(
      PutComplaintModel complaint) async {
    try {
      final result = await remoteDataSource.putComplaint(complaint);

      return result.fold(
        (failure) => Left(failure),
        (message) => Right(message),
      );
    } catch (e) {
      return const Left(ServerFailure(message: "Gagal memperbarui pengaduan"));
    }
  }
}
