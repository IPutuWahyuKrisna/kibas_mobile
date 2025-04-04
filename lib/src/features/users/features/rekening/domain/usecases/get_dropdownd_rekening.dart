import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failure.dart';
import '../repositories/rekening_repository.dart';

class GetGolonganListUseCase {
  final RekeningRepository repository;
  GetGolonganListUseCase(this.repository);

  Future<Either<Failure, List<Map<String, dynamic>>>> execute() {
    return repository.getGolonganList();
  }
}

class GetKecamatanListUseCase {
  final RekeningRepository repository;
  GetKecamatanListUseCase(this.repository);

  Future<Either<Failure, List<Map<String, dynamic>>>> execute() {
    return repository.getKecamatanList();
  }
}

class GetKelurahanListUseCase {
  final RekeningRepository repository;
  GetKelurahanListUseCase(this.repository);

  Future<Either<Failure, List<Map<String, dynamic>>>> execute() {
    return repository.getKelurahanList();
  }
}

class GetAreaListUseCase {
  final RekeningRepository repository;
  GetAreaListUseCase(this.repository);

  Future<Either<Failure, List<Map<String, dynamic>>>> execute() {
    return repository.getAreaList();
  }
}

class GetRayonListUseCase {
  final RekeningRepository repository;
  GetRayonListUseCase(this.repository);

  Future<Either<Failure, List<Map<String, dynamic>>>> execute() {
    return repository.getRayonList();
  }
}
