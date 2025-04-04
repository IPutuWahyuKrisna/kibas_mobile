import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failure.dart';
import '../entities/area_pegawai_entity.dart';
import '../repositories/area_pegawai_repository.dart';

class GetAreaPegawaiUseCase {
  final AreaPegawaiRepositoryDomain repository;

  GetAreaPegawaiUseCase(this.repository);

  Future<Either<Failure, AreaPegawai>> execute(String token) {
    return repository.getAreaPegawai(token);
  }
}
