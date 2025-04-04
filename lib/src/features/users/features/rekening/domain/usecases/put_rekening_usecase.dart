import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failure.dart';
import '../entities/rekening_entity.dart';
import '../repositories/rekening_repository.dart';

class PutRekeningUseCase {
  final RekeningRepository repository;
  PutRekeningUseCase(this.repository);

  Future<Either<Failure, RekeningEntity>> call(Map<String, dynamic> data) {
    return repository.putRekening(data);
  }
}
