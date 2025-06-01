import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../../core/error/exceptions.dart';
import '../../../../../../core/error/failure.dart';
import '../../../../../../core/utils/user_local_storage_service.dart';
import '../../domain/entities/announcement_entity.dart';
import '../../domain/entities/log_out.dart';
import '../../domain/repositories/dashboard_repository_domain.dart';
import '../datasources/dashboard_remote_datasource.dart';

class DashboardRepositoryImpl implements DashboardRepositoryDomain {
  final DashboardRemoteDataSource remoteDataSource;
  final UserLocalStorageService localStorageService;

  DashboardRepositoryImpl({
    required this.remoteDataSource,
    required this.localStorageService,
  });

  @override
  Future<Either<Failure, List<Announcement>>> getAllAnnouncements(
      String token) async {
    try {
      final announcements = await remoteDataSource.getAllAnnouncements(token);

      return Right(announcements);
    } on UnauthenticatedException catch (e) {
      await localStorageService.clearUser();
      return Left(UnauthenticatedFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on DioException catch (e) {
      await localStorageService.clearUser();
      return Left(
          UnauthenticatedFailure(message: "Anda belum melakukan login"));
    } catch (e) {
      print("masuk kesini");
      return const Left(UnknownFailure(
        message: "Terjadi kesalahan yang tidak diketahui",
      ));
    }
  }

  @override
  Future<Either<Failure, Logout>> logout() async {
    try {
      final user = localStorageService.getUser();
      if (user != null) {
        // 🟢 Panggil API logout dengan token
        final logoutResponse = await remoteDataSource.logout(user.token);
        await localStorageService
            .clearUser(); // 🟢 Hapus data user dari local storage
        return Right(logoutResponse); // 🟢 Kembalikan Logout entity
      } else {
        return const Left(CacheFailure(message: "User tidak ditemukan"));
      }
    } on DioException catch (e) {
      return Left(
          ServerFailure(message: e.message ?? "Terjadi kesalahan pada server"));
    } catch (e) {
      return const Left(
          UnknownFailure(message: "Terjadi kesalahan yang tidak diketahui"));
    }
  }
}
