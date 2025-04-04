import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failure.dart';
import '../entities/announcement_entity.dart';
import '../repositories/dashboard_repository_domain.dart';

class GetAllAnnouncementsUseCase {
  final DashboardRepositoryDomain repository;

  GetAllAnnouncementsUseCase(this.repository);

  Future<Either<Failure, List<Announcement>>> execute(String token) async {
    return await repository.getAllAnnouncements(token);
  }
}
