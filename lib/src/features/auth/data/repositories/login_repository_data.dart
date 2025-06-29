import 'package:dartz/dartz.dart';
import 'package:kibas_mobile/src/features/auth/data/models/user_model.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/utils/user_local_storage_service.dart';
import '../../domain/entities/register_entity.dart';
import '../../domain/repositories/login_repository_domain.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/register_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final UserLocalStorageService localStorageService;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localStorageService,
  });

  @override
  Future<Either<Failure, UserModel>> login(
      String email, String password) async {
    try {
      // 🟢 Request login ke remote data source
      final userModel = await remoteDataSource.login(email, password);
      return Right(userModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } on UnknownException catch (e) {
      return Left(UnknownFailure(message: e.message));
    } catch (e) {
      return const Left(
          UnknownFailure(message: "Terjadi kesalahan yang tidak diketahui"));
    }
  }

  @override
  Future<Either<Failure, String>> register(RegisterEntity registerData) async {
    try {
      // Simpan hasil dari remote data source
      final result = await remoteDataSource.register(RegisterModel(
        email: registerData.email,
        password: registerData.password,
        passwordConfirmation: registerData.passwordConfirmation,
        noRekening: registerData.noRekening,
        nikPelanggan: registerData.nikPelanggan,
        noTelepon: registerData.noTelepon,
      ));

      // Propagasi hasil langsung ke atas
      return result;
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } on UnknownException catch (e) {
      return Left(UnknownFailure(message: e.message));
    } catch (e) {
      print(e.toString());
      return const Left(UnknownFailure(
          message: "Terjadi kesalahan yang tidak diketahui(repository)"));
    }
  }
  // return remoteDataSource.register(RegisterModel(
  //   email: registerData.email,
  //   password: registerData.password,
  //   passwordConfirmation: registerData.passwordConfirmation,
  //   noPelanggan: registerData.noPelanggan,
  //   nikPelanggan: registerData.nikPelanggan,
  // ));

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
