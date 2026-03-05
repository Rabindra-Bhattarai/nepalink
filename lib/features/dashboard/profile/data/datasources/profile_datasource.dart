import 'dart:io';
import 'package:nepalink/features/dashboard/profile/data/models/profile_api_model.dart';
import 'package:nepalink/features/dashboard/profile/data/models/profile_hive_model.dart';

/// Remote datasource interface
abstract interface class IProfileRemoteDataSource {
  Future<ProfileApiModel> getProfile(String userId);
  Future<ProfileApiModel> updateProfile({
    required String userId,
    required String name,
    required String phone,
  });
  Future<ProfileApiModel> uploadProfilePicture({
    required String userId,
    required File image,
  });
}

/// Local datasource interface
abstract interface class IProfileLocalDataSource {
  Future<ProfileHiveModel?> getProfile();
  Future<void> saveProfile(ProfileHiveModel profile);
  Future<void> clearProfile();
}
