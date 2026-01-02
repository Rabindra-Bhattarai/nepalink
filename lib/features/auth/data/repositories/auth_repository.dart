import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/core/errors/failures.dart';
import 'package:nepalink/features/auth/data/datasources/auth_datasource.dart';
import 'package:nepalink/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:nepalink/features/auth/data/models/user_hive_model.dart';
import 'package:nepalink/features/auth/domain/entities/user_entity.dart';
import 'package:nepalink/features/auth/domain/repositories/auth_repository.dart';

// Provider
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final authDatasource = ref.read(authLocalDatasourceProvider);
  return AuthRepository(authDatasource: authDatasource);
});

class AuthRepository implements IAuthRepository {
  final IAuthDataSource _authDataSource;

  AuthRepository({required IAuthDataSource authDatasource})
    : _authDataSource = authDatasource;

  @override
  Future<Either<Failure, bool>> register(UserEntity user) async {
    try {
      // Check if email already exists
      final existingUser = await _authDataSource.getUserByEmail(user.email);
      if (existingUser != null) {
        return const Left(
          LocalDatabaseFailure(message: "Email already registered"),
        );
      }

      final userModel = UserHiveModel(
        userid: user.userid,
        name: user.name,
        email: user.email,
        phone: user.phone,
        password: user.password,
      );

      await _authDataSource.register(userModel);
      return const Right(true);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login(
    String email,
    String password,
  ) async {
    try {
      final model = await _authDataSource.login(email, password);
      if (model != null) {
        final entity = model.toEntity();
        return Right(entity);
      }
      return const Left(
        LocalDatabaseFailure(message: "Invalid email or password"),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final model = await _authDataSource.getCurrentUser();
      if (model != null) {
        final entity = model.toEntity();
        return Right(entity);
      }
      return const Left(LocalDatabaseFailure(message: "No user logged in"));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      final result = await _authDataSource.logout();
      if (result) {
        return const Right(true);
      }
      return const Left(LocalDatabaseFailure(message: "Failed to logout"));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
