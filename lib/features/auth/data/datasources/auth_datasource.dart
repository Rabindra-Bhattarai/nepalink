import 'package:nepalink/features/auth/data/models/user_hive_model.dart';

abstract interface class IAuthDataSource {
  Future<UserHiveModel> register(UserHiveModel user);
  Future<UserHiveModel?> login(String email, String password);
  Future<UserHiveModel?> getCurrentUser();
  Future<bool> logout();
  Future<UserHiveModel?> getUserById(String userid);
  Future<UserHiveModel?> getUserByEmail(String email);
  Future<bool> updateUser(UserHiveModel user);
  Future<bool> deleteUser(String userid);
}
