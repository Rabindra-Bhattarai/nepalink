import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/core/services/hive/hive_service.dart';
import 'package:nepalink/features/auth/data/datasources/auth_datasource.dart';
import 'package:nepalink/features/auth/data/models/user_hive_model.dart';

// Provider
final authLocalDatasourceProvider = Provider<AuthLocalDatasource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  return AuthLocalDatasource(hiveService: hiveService);
});

class AuthLocalDatasource implements IAuthDataSource {
  final HiveService _hiveService;

  AuthLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<UserHiveModel> register(UserHiveModel user) async {
    return await _hiveService.register(user);
  }

  @override
  Future<UserHiveModel?> login(String email, String password) async {
    try {
      return _hiveService.login(email, password);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<UserHiveModel?> getCurrentUser() async {
    try {
      return _hiveService.getCurrentUser();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      return await _hiveService.logout();
    } catch (e) {
      return false;
    }
  }

  @override
  Future<UserHiveModel?> getUserById(String userid) async {
    try {
      return _hiveService.getUserById(userid);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<UserHiveModel?> getUserByEmail(String email) async {
    try {
      return _hiveService.getUserByEmail(email);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> updateUser(UserHiveModel user) async {
    try {
      return await _hiveService.updateUser(user);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteUser(String userid) async {
    try {
      await _hiveService.deleteUser(userid);
      return true;
    } catch (e) {
      return false;
    }
  }
}
