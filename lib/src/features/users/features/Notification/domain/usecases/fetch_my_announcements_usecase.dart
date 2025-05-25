import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failure.dart';
import '../entities/myannouncement.dart';
import '../repositories/my_announcement_repository.dart';

class FetchMyAnnouncementsUseCase {
  final MyAnnouncementRepository repository;

  FetchMyAnnouncementsUseCase(this.repository);

  Future<Either<Failure, List<MyAnnouncementEntity>>> execute() {
    return repository.fetchMyAnnouncements();
  }
}
