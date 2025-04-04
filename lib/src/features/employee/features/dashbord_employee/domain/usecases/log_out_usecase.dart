import 'package:dartz/dartz.dart';
import 'package:kibas_mobile/src/features/employee/features/dashbord_employee/domain/entities/log_out.dart';
import '../../../../../../core/error/failure.dart';
import '../repositories/dashboard_repository_domain.dart';

class LogoutUseCase {
  final DashboardRepositoryDomain repository;

  LogoutUseCase(this.repository);

  Future<Either<Failure, Logout>> execute() async {
    return await repository.logout();
  }
}
