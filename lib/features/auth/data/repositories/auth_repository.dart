import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:nepalink/core/errors/failures.dart';
import 'package:nepalink/core/services/connectivity/network_info.dart';
import 'package:nepalink/features/auth/data/datasources/auth_datasource.dart';
import 'package:nepalink/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:nepalink/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:nepalink/features/auth/data/models/user_hive_model.dart';
import 'package:nepalink/features/auth/data/models/auth_api_model.dart';
import 'package:nepalink/features/auth/domain/entities/user_entity.dart';
import 'package:nepalink/features/auth/domain/repositories/auth_repository.dart';

/// Provider for dependency injection
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final local = ref.read(authLocalDatasourceProvider);
  final remote = ref.read(authRemoteDataSourceProvider);
  final networkInfo = ref.read(networkInfoProvider);

  return AuthRepository(
    localDataSource: local,
    remoteDataSource: remote,
    networkInfo: networkInfo,
  );
});

class AuthRepository implements IAuthRepository {
  final IAuthLocalDataSource _local;
  final IAuthRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  AuthRepository({
    required IAuthLocalDataSource localDataSource,
    required IAuthRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  }) : _local = localDataSource,
       _remote = remoteDataSource,
       _networkInfo = networkInfo;

  /// Register user
  @override
  Future<Either<Failure, bool>> register(UserEntity user) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = UserApiModel.fromEntity(user);
        await _remote.registerUser(apiModel);
        return const Right(true);
      } on DioException catch (e) {
        String errorMessage = "Failed to register user!";
        final messageData = e.response?.data['message'];
        if (messageData != null) {
          if (messageData is String) {
            errorMessage = messageData;
          } else if (messageData is List && messageData.isNotEmpty) {
            errorMessage = messageData.first.toString();
          }
        }
        return Left(
          ApiFailure(statusCode: e.response?.statusCode, message: errorMessage),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final existingUser = await _local.getUserByEmail(user.email);
        if (existingUser != null) {
          return const Left(
            LocalDatabaseFailure(message: "Email already registered"),
          );
        }
        final hiveModel = UserHiveModel(
          userid: user.userid,
          name: user.name,
          email: user.email,
          phone: user.phone,
          password: user.password,
        );
        await _local.register(hiveModel);
        return const Right(true);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  /// Login user
  @override
  Future<Either<Failure, UserEntity>> login(
    String email,
    String password,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final userModel = await _remote.loginUser(email, password);
        if (userModel != null) {
          return Right(userModel.toEntity());
        }
        return const Left(ApiFailure(message: "Invalid email or password"));
      } on DioException catch (e) {
        String errorMessage = "Failed to login user!";
        final messageData = e.response?.data['message'];
        if (messageData != null) {
          if (messageData is String) {
            errorMessage = messageData;
          } else if (messageData is List && messageData.isNotEmpty) {
            errorMessage = messageData.first.toString();
          }
        }
        return Left(
          ApiFailure(statusCode: e.response?.statusCode, message: errorMessage),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final user = await _local.login(email, password);
        if (user != null) return Right(user.toEntity());
        return const Left(
          LocalDatabaseFailure(message: "Invalid email or password"),
        );
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  /// Get current user
  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    if (await _networkInfo.isConnected) {
      try {
        final userModel = await _remote.getCurrentUser();
        if (userModel != null) return Right(userModel.toEntity());
        return const Left(ApiFailure(message: "No user logged in"));
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            statusCode: e.response?.statusCode,
            message:
                e.response?.data['message'] ?? "Failed to get current user!",
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final user = await _local.getCurrentUser();
        if (user != null) return Right(user.toEntity());
        return const Left(LocalDatabaseFailure(message: "No user logged in"));
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  /// Logout user
  @override
  Future<Either<Failure, bool>> logout() async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _remote.logoutUser();
        if (result) return const Right(true);
        return const Left(ApiFailure(message: "Failed to logout"));
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            statusCode: e.response?.statusCode,
            message: e.response?.data['message'] ?? "Failed to logout",
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final result = await _local.logout();
        if (result) return const Right(true);
        return const Left(LocalDatabaseFailure(message: "Failed to logout"));
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }
}
