import 'package:dartz/dartz.dart';
import 'package:kibas_mobile/src/features/users/features/dashboard_user/data/models/edit_user.dart';
import '../../../../../../core/error/failure.dart';

abstract class PutUserRepositoryDomain {
  Future<Either<Failure, String>> putUser(EditUserModel putUser);

  Future<Either<Failure, List<Map<String, dynamic>>>> getGolonganList();
  Future<Either<Failure, List<Map<String, dynamic>>>> getKecamatanList();
  Future<Either<Failure, List<Map<String, dynamic>>>> getKelurahanList();
  Future<Either<Failure, List<Map<String, dynamic>>>> getAreaList();
}
