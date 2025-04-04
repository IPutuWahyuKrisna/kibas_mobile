import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failure.dart';
import '../entities/announcement_entity.dart';
import '../entities/log_out.dart';

abstract class DashboardRepositoryDomain {
  Future<Either<Failure, List<Announcement>>> getAllAnnouncements(String token);
  Future<Either<Failure, Logout>> logout();
}
