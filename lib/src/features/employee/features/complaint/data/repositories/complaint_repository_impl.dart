import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failure.dart';
import '../../domain/entities/complaint_entity.dart';
import '../../domain/repositories/complaint_repository.dart';
import '../datasources/complaint_remote_data_source.dart';

class ComplaintRepositoryImpl implements ComplaintRepositoryDomain {
  final ComplaintRemoteDataSource remoteDataSource;

  ComplaintRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Complaint>>> getAllComplaints(
      String token) async {
    try {
      final complaints = await remoteDataSource.getAllComplaints(token);
      return Right(complaints);
    } catch (e) {
      return const Left(
          ServerFailure(message: 'Gagal mengambil data pengaduan!'));
    }
  }

  @override
  Future<Either<Failure, Complaint>> getComplaintDetail(
      String token, int id) async {
    try {
      final complaint = await remoteDataSource.getComplaintDetail(token, id);
      return Right(complaint);
    } catch (e) {
      return const Left(
          ServerFailure(message: 'Gagal mengambil detail pengaduan!'));
    }
  }
}
