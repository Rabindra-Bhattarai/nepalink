// lib/features/dashboard/profile/data/repositories/profile_repository_impl.dart

import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nepalink/core/errors/failures.dart';
import 'package:nepalink/features/dashboard/profile/data/datasources/local/profile_local_datasource.dart';
import 'package:nepalink/features/dashboard/profile/data/datasources/remote/profile_remote_datasource.dart';
import 'package:nepalink/features/dashboard/profile/data/datasources/profile_datasource.dart';
import 'package:nepalink/features/dashboard/profile/data/models/profile_hive_model.dart';
import 'package:nepalink/features/dashboard/profile/domain/entities/profile_entity.dart';
import 'package:nepalink/features/dashboard/profile/domain/repositories/profile_repository.dart';

final profileRepositoryProvider = Provider<IProfileRepository>((ref) {
  return ProfileRepositoryImpl(
    remote: ref.read(profileRemoteDataSourceProvider),
    local: ref.read(profileLocalDataSourceProvider),
  );
});

class ProfileRepositoryImpl implements IProfileRepository {
  final IProfileRemoteDataSource _remote;
  final IProfileLocalDataSource _local;
  // ✅ Only used to clear auth_token on logout (FlutterSecureStorage)
  final _secureStorage = const FlutterSecureStorage();
  static const _tokenKey = 'auth_token';

  ProfileRepositoryImpl({
    required IProfileRemoteDataSource remote,
    required IProfileLocalDataSource local,
  }) : _remote = remote,
       _local = local;

  @override
  Future<Either<Failure, ProfileEntity>> getProfile(String userId) async {
    try {
      final model = await _remote.getProfile(userId);
      await _local.saveProfile(ProfileHiveModel.fromEntity(model.toEntity()));
      return Right(model.toEntity());
    } catch (_) {
      // Fall back to Hive cache
      try {
        final cached = await _local.getProfile();
        if (cached != null) return Right(cached.toEntity());
        return Left(
          ApiFailure(message: 'No profile found. Check your connection.'),
        );
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateProfile({
    required String userId,
    required String name,
    required String phone,
  }) async {
    try {
      final model = await _remote.updateProfile(
        userId: userId,
        name: name,
        phone: phone,
      );
      await _local.saveProfile(ProfileHiveModel.fromEntity(model.toEntity()));
      return Right(model.toEntity());
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> uploadProfilePicture({
    required String userId,
    required File image,
  }) async {
    try {
      final model = await _remote.uploadProfilePicture(
        userId: userId,
        image: image,
      );
      await _local.saveProfile(ProfileHiveModel.fromEntity(model.toEntity()));
      return Right(model.toEntity());
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Clear JWT from secure storage
      await _secureStorage.delete(key: _tokenKey);
      // Clear Hive profile cache
      await _local.clearProfile();
      // Note: SharedPreferences session is cleared by ProfileViewModel
      // via UserSessionService.clearSession()
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
