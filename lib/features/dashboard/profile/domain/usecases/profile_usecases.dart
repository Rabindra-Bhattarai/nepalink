import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/core/errors/failures.dart';
import 'package:nepalink/core/usecases/app_usecases.dart';
import 'package:nepalink/features/dashboard/profile/data/repositories/profile_repository_impl.dart';
import 'package:nepalink/features/dashboard/profile/domain/entities/profile_entity.dart';
import 'package:nepalink/features/dashboard/profile/domain/repositories/profile_repository.dart';

//  Get Profile
final getProfileUsecaseProvider = Provider<GetProfileUsecase>((ref) {
  return GetProfileUsecase(repository: ref.read(profileRepositoryProvider));
});

class GetProfileUsecase implements UsecaseWithParms<ProfileEntity, String> {
  final IProfileRepository _repo;
  GetProfileUsecase({required IProfileRepository repository})
    : _repo = repository;

  @override
  Future<Either<Failure, ProfileEntity>> call(String userId) =>
      _repo.getProfile(userId);
}

// ── Update Profile ────────────────────────────────────────────────────────────
class UpdateProfileParams {
  final String userId;
  final String name;
  final String phone;
  UpdateProfileParams({
    required this.userId,
    required this.name,
    required this.phone,
  });
}

final updateProfileUsecaseProvider = Provider<UpdateProfileUsecase>((ref) {
  return UpdateProfileUsecase(repository: ref.read(profileRepositoryProvider));
});

class UpdateProfileUsecase
    implements UsecaseWithParms<ProfileEntity, UpdateProfileParams> {
  final IProfileRepository _repo;
  UpdateProfileUsecase({required IProfileRepository repository})
    : _repo = repository;

  @override
  Future<Either<Failure, ProfileEntity>> call(UpdateProfileParams params) =>
      _repo.updateProfile(
        userId: params.userId,
        name: params.name,
        phone: params.phone,
      );
}

//  Upload Profile Picture
class UploadPictureParams {
  final String userId;
  final File image;
  UploadPictureParams({required this.userId, required this.image});
}

final uploadProfilePictureUsecaseProvider =
    Provider<UploadProfilePictureUsecase>((ref) {
      return UploadProfilePictureUsecase(
        repository: ref.read(profileRepositoryProvider),
      );
    });

class UploadProfilePictureUsecase
    implements UsecaseWithParms<ProfileEntity, UploadPictureParams> {
  final IProfileRepository _repo;
  UploadProfilePictureUsecase({required IProfileRepository repository})
    : _repo = repository;

  @override
  Future<Either<Failure, ProfileEntity>> call(UploadPictureParams params) =>
      _repo.uploadProfilePicture(userId: params.userId, image: params.image);
}

// ─ Logout
final logoutUsecaseProvider = Provider<LogoutUsecase>((ref) {
  return LogoutUsecase(repository: ref.read(profileRepositoryProvider));
});

class LogoutUsecase implements UsecaseWithoutParms<void> {
  final IProfileRepository _repo;
  LogoutUsecase({required IProfileRepository repository}) : _repo = repository;

  @override
  Future<Either<Failure, void>> call() => _repo.logout();
}
