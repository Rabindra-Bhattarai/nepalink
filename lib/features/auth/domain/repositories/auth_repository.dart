import 'package:nepalink/core/errors/failures.dart';
import '../entities/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, bool>> register(UserEntity user);
  Future<Either<Failure, UserEntity>> login(String email, String password);
  Future<Either<Failure, UserEntity?>> getCurrentUser();
  Future<Either<Failure, bool>> logout();
}
