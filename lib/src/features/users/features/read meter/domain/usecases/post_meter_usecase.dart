import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:kibas_mobile/src/core/error/failure.dart';
import '../repositories/read_meter_repository.dart';

class SubmitPostmeterUseCase {
  final MeterRepositoryDomain repository;

  SubmitPostmeterUseCase(this.repository);

  Future<Either<Failure, String>> execute({
    required File imageFile,
    required String noRekening,
    required String angkaFinal,
  }) async {
    return await repository.postMeter(
      linkFoto: imageFile,
      noRekening: noRekening,
      angkaFinal: angkaFinal,
    );
  }
}
