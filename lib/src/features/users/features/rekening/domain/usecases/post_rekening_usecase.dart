import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failure.dart';
import '../entities/rekening_entity.dart';
import '../repositories/rekening_repository.dart';

class PostRekeningUseCase {
  final RekeningRepository repository;

  PostRekeningUseCase(this.repository);

  Future<Either<Failure, RekeningEntity>> call(Map<String, dynamic> data) {
    return repository.postRekening(data);
  }
}
