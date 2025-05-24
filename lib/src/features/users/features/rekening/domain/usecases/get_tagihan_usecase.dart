import 'package:dartz/dartz.dart';

import '../../../../../../core/error/failure.dart';
import '../entities/tagihan.dart';
import '../repositories/rekening_repository.dart';

class GetTagihanUseCase {
  final RekeningRepository repository;

  GetTagihanUseCase(this.repository);

  Future<Either<Failure, List<TagihanEntity>>> execute() {
    return repository.getTagihan();
  }
}
