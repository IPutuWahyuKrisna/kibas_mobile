// lib/domain/repositories/meter_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failure.dart';
import '../entities/read_meter.dart';
import 'dart:io';

abstract class MeterRepositoryDomain {
  Future<Either<Failure, List<ReadMeterEntity>>> fetchReadMeter();
  Future<Either<Failure, String>> postMeter({
    required File linkFoto,
    required String angkaFinal,
  });
}
