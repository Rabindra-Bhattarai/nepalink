import 'dart:io';
import 'package:nepalink/features/auth/data/models/auth_api_model.dart';
import 'package:nepalink/features/auth/data/models/user_hive_model.dart';

abstract interface class IAuthLocalDataSource {
  Future<UserHiveModel> register(UserHiveModel user);
  Future<UserHiveModel?> login(String email, String password);
  Future<UserHiveModel?> getCurrentUser();
  Future<bool> logout();
  Future<UserHiveModel?> getUserById(String userid);
  Future<UserHiveModel?> getUserByEmail(String email);
  Future<bool> updateUser(UserHiveModel user);
  Future<bool> deleteUser(String userid);
}

abstract interface class IAuthRemoteDataSource {
  Future<UserApiModel> registerUser(UserApiModel user);
  Future<UserApiModel?> loginUser(String email, String password);
  Future<UserApiModel?> getCurrentUser();
  Future<bool> logoutUser();
  Future<UserApiModel?> uploadProfileImage(String userId, File photo);
}
