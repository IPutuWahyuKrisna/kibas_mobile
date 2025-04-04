import 'package:dartz/dartz.dart';
import 'package:kibas_mobile/src/features/users/features/dashboard_user/data/models/edit_user.dart';
import 'package:kibas_mobile/src/features/users/features/dashboard_user/domain/repositories/put_user_repository_domain.dart';
import '../../../../../../core/error/failure.dart';

class PutUserUseCase {
  final PutUserRepositoryDomain repository;

  PutUserUseCase(this.repository);

  Future<Either<Failure, String>> execute(EditUserModel putUser) {
    return repository.putUser(putUser);
  }
}
