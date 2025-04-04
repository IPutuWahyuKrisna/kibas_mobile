import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failure.dart';
import '../entities/rekening_entity.dart';
import '../repositories/rekening_repository.dart';

class GetRekeningUseCase {
  final RekeningRepository repository;

  GetRekeningUseCase(this.repository);

  Future<Either<Failure, List<RekeningEntity>>> call(int pelangganId) {
    return repository.getRekening(pelangganId);
  }
}
