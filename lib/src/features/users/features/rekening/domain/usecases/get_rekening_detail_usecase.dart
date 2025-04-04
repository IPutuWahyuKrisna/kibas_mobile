import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failure.dart';
import '../entities/rekening_detail_entity.dart';
import '../repositories/rekening_repository.dart';

class GetRekeningDetailUseCase {
  final RekeningRepository repository;

  GetRekeningDetailUseCase(this.repository);

  Future<Either<Failure, RekeningDetailEntity>> call(int rekeningId) {
    return repository.getRekeningDetail(rekeningId);
  }
}
