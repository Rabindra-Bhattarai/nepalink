import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/core/errors/failures.dart';
import 'package:nepalink/features/auth/domain/entities/user_entity.dart';
import 'package:nepalink/features/auth/domain/repositories/auth_repository.dart';
import 'package:nepalink/features/auth/data/repositories/auth_repository.dart';

/// Provider for dependency injection
final uploadProfileImageUsecaseProvider = Provider<UploadProfileImageUsecase>((
  ref,
) {
  final authRepository = ref.read(authRepositoryProvider);
  return UploadProfileImageUsecase(authRepository: authRepository);
});

/// Use case class
class UploadProfileImageUsecase {
  final IAuthRepository _authRepository;

  UploadProfileImageUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  /// Call method to upload profile image
  Future<Either<Failure, UserEntity>> call(String userId, File photo) {
    return _authRepository.uploadProfileImage(userId, photo);
  }
}
