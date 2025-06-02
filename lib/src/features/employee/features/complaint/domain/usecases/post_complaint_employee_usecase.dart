// post_complaint_employee_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failure.dart';
import '../repositories/complaint_repository.dart';

import 'dart:io';

class PostComplaintEmployeeUseCase {
  final ComplaintEmployeeRepository repository;

  PostComplaintEmployeeUseCase(this.repository);

  Future<Either<Failure, String>> execute({
    required int pengaduanId,
    required File buktiFotoSelesai,
    required String catatan,
  }) {
    return repository.postComplaintEmployee(
      pengaduanId: pengaduanId,
      buktiFotoSelesai: buktiFotoSelesai,
      catatan: catatan,
    );
  }
}
