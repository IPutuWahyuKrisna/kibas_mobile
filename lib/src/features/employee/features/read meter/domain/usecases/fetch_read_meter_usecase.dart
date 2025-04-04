// lib/domain/usecases/get_list_meter.dart
import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failure.dart';
import '../entities/read_meter.dart';
import '../repositories/read_meter_repository.dart';

class GetListMeterUseCase {
  final MeterRepositoryDomain repository;

  GetListMeterUseCase(this.repository);

  Future<Either<Failure, List<ReadMeter>>> execute(String token) {
    return repository.getListMeter(token);
  }
}
