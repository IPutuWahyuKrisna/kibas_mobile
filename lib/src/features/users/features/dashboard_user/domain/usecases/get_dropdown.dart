import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failure.dart';
import '../repositories/put_user_repository_domain.dart';

class GetGolonganListUseCase {
  final PutUserRepositoryDomain repository;
  GetGolonganListUseCase(this.repository);

  Future<Either<Failure, List<Map<String, dynamic>>>> execute() {
    return repository.getGolonganList();
  }
}

class GetKecamatanListUseCase {
  final PutUserRepositoryDomain repository;
  GetKecamatanListUseCase(this.repository);

  Future<Either<Failure, List<Map<String, dynamic>>>> execute() {
    return repository.getKecamatanList();
  }
}

class GetKelurahanListUseCase {
  final PutUserRepositoryDomain repository;
  GetKelurahanListUseCase(this.repository);

  Future<Either<Failure, List<Map<String, dynamic>>>> execute() {
    return repository.getKelurahanList();
  }
}

class GetAreaListUseCase {
  final PutUserRepositoryDomain repository;
  GetAreaListUseCase(this.repository);

  Future<Either<Failure, List<Map<String, dynamic>>>> execute() {
    return repository.getAreaList();
  }
}
