import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:kibas_mobile/src/features/users/features/complaint_users/data/models/put_complaint_model.dart';
import '../../../../../../core/error/failure.dart';
import '../../domain/entities/complaint_users_entity.dart';
import '../../domain/repositories/complaint_users_repository.dart';
import '../datasources/complaint_users_remote_data_source.dart';

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
  Future<Either<Failure, ComplaintUsers>> getComplaintDetailUsers(
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
  Future<Either<Failure, String>> postComplaint(
      {required File image, required String complaint}) async {
    try {
      final result = await remoteDataSource.postComplaint(
          image: image, complaint: complaint);
      return result.fold(
        (failure) => Left(failure),
        (message) => Right(message),
      );
    } on DioException catch (e) {
      return Left(
          ServerFailure(message: "Gagal menghubungi server: ${e.message}"));
    } catch (e) {
      return Left(
          UnknownFailure(message: "Kesalahan tidak terduga: ${e.toString()}"));
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
