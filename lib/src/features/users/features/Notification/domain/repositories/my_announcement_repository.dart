import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failure.dart';
import '../entities/myannouncement.dart';

abstract class MyAnnouncementRepository {
  Future<Either<Failure, List<MyAnnouncementEntity>>> fetchMyAnnouncements();
}
