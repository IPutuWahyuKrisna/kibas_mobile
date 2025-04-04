import 'package:dartz/dartz.dart';

import '../../../../../../core/error/failure.dart';
import '../entities/area_pegawai_entity.dart';

abstract class AreaPegawaiRepositoryDomain {
  Future<Either<Failure, AreaPegawai>> getAreaPegawai(String token);
}
