// complaint_repository.dart
import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failure.dart';
import '../entities/complaint_entity.dart';

abstract class ComplaintEmployeeRepository {
  Future<Either<Failure, List<ComplaintEmployee>>> fetchComplaintList();

  Future<Either<Failure, String>> postComplaintEmployee({
    required int pengaduanId,
    required File buktiFotoSelesai,
    required String catatan,
  });
}
