import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failure.dart';
import '../../domain/entities/myannouncement.dart';
import '../../domain/repositories/my_announcement_repository.dart';
import '../datasources/my_announcement_remote_data_source.dart';

class MyAnnouncementRepositoryImpl implements MyAnnouncementRepository {
  final MyAnnouncementRemoteDataSource remoteDataSource;

  MyAnnouncementRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<MyAnnouncementEntity>>>
      fetchMyAnnouncements() async {
    try {
      final result = await remoteDataSource.fetchMyAnnouncements();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
