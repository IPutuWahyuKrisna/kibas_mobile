// complaint_repository_impl.dart
import 'dart:io';

import 'package:dartz/dartz.dart';
import '../../../../../../core/error/exceptions.dart';
import '../../../../../../core/error/failure.dart';
import '../../domain/entities/complaint_entity.dart';
import '../../domain/repositories/complaint_repository.dart';
import '../datasources/complaint_remote_data_source.dart';
import '../models/post_complaint_employee.dart';

class ComplaintEmployeeRepositoryImpl implements ComplaintEmployeeRepository {
  final ComplaintRemoteDataSource remoteDataSource;

  ComplaintEmployeeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ComplaintEmployee>>> fetchComplaintList() async {
    try {
      final result = await remoteDataSource.getComplaints();
      return Right(result);
    } on ServerException catch (e) {
      if (e is UnauthenticatedException) {
        return Left(UnauthenticatedFailure(message: e.message));
      }
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return const Left(
          UnknownFailure(message: 'Terjadi kesalahan tidak diketahui'));
    }
  }

  @override
  Future<Either<Failure, String>> postComplaintEmployee({
    required int pengaduanId,
    required File buktiFotoSelesai,
    required String catatan,
  }) async {
    try {
      final model = ComplaintCompletion(
        pengaduanId: pengaduanId,
        buktiFotoSelesai: buktiFotoSelesai,
        catatan: catatan,
      );
      return await remoteDataSource.postComplaint(model);
    } on ServerException catch (e) {
      if (e is UnauthenticatedException) {
        return Left(UnauthenticatedFailure(message: e.message));
      }
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return const Left(
          UnknownFailure(message: 'Terjadi kesalahan tidak diketahui'));
    }
  }
}
