import '../../../../core/error/failure.dart';
import '../../data/models/user_model.dart';
import 'package:dartz/dartz.dart';

import '../entities/register_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserModel>> login(String email, String password);
  Future<Either<Failure, String>> register(RegisterEntity registerData);

  Future<Either<Failure, List<Map<String, dynamic>>>> getGolonganList();
  Future<Either<Failure, List<Map<String, dynamic>>>> getKecamatanList();
  Future<Either<Failure, List<Map<String, dynamic>>>> getKelurahanList();
  Future<Either<Failure, List<Map<String, dynamic>>>> getAreaList();
}
