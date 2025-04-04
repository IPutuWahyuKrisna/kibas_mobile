import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failure.dart';
import '../../../../../../core/utils/user_local_storage_service.dart';
import '../../domain/repositories/put_user_repository_domain.dart';
import '../datasources/put_remote_datasource.dart';
import '../models/edit_user.dart';

class PutUserRepositoryImpl implements PutUserRepositoryDomain {
  final PutRemoteDataSource remoteDataSource;
  final UserLocalStorageService localStorageService;

  PutUserRepositoryImpl({
    required this.remoteDataSource,
    required this.localStorageService,
  });

  @override
  Future<Either<Failure, String>> putUser(EditUserModel putUser) {
    return remoteDataSource.putUser(EditUserModel(
      email: putUser.email,
      password: putUser.password,
      passwordConfirmation: putUser.passwordConfirmation,
      noPelanggan: putUser.noPelanggan,
      namaPelanggan: putUser.namaPelanggan,
      nikPelanggan: putUser.nikPelanggan,
      alamatPelanggan: putUser.alamatPelanggan,
      golonganId: putUser.golonganId,
      kecamatanId: putUser.kecamatanId,
      kelurahanId: putUser.kelurahanId,
      areaId: putUser.areaId,
    ));
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getGolonganList() {
    return remoteDataSource.getGolonganList();
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getKecamatanList() {
    return remoteDataSource.getKecamatanList();
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getKelurahanList() {
    return remoteDataSource.getKelurahanList();
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getAreaList() {
    return remoteDataSource.getAreaList();
  }
}
