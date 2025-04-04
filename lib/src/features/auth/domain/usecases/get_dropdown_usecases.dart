import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repositories/login_repository_domain.dart';

class GetGolonganListUseCase {
  final AuthRepository repository;
  GetGolonganListUseCase(this.repository);

  Future<Either<Failure, List<Map<String, dynamic>>>> execute() {
    return repository.getGolonganList();
  }
}

class GetKecamatanListUseCase {
  final AuthRepository repository;
  GetKecamatanListUseCase(this.repository);

  Future<Either<Failure, List<Map<String, dynamic>>>> execute() {
    return repository.getKecamatanList();
  }
}

class GetKelurahanListUseCase {
  final AuthRepository repository;
  GetKelurahanListUseCase(this.repository);

  Future<Either<Failure, List<Map<String, dynamic>>>> execute() {
    return repository.getKelurahanList();
  }
}

class GetAreaListUseCase {
  final AuthRepository repository;
  GetAreaListUseCase(this.repository);

  Future<Either<Failure, List<Map<String, dynamic>>>> execute() {
    return repository.getAreaList();
  }
}
