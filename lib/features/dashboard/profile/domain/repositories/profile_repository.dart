import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:nepalink/core/errors/failures.dart';
import 'package:nepalink/features/dashboard/profile/domain/entities/profile_entity.dart';

abstract interface class IProfileRepository {
  Future<Either<Failure, ProfileEntity>> getProfile(String userId);
  Future<Either<Failure, ProfileEntity>> updateProfile({
    required String userId,
    required String name,
    required String phone,
  });
  Future<Either<Failure, ProfileEntity>> uploadProfilePicture({
    required String userId,
    required File image,
  });
  Future<Either<Failure, void>> logout();
}
