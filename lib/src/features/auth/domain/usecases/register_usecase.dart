import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/register_entity.dart';
import '../repositories/login_repository_domain.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, String>> execute(RegisterEntity registerData) {
    return repository.register(registerData);
  }
}
