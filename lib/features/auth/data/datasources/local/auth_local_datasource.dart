import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/core/services/hive/hive_service.dart';
import 'package:nepalink/core/services/storage/user_session_service.dart';
import 'package:nepalink/features/auth/data/datasources/auth_datasource.dart';
import 'package:nepalink/features/auth/data/models/user_hive_model.dart';

// Provider
final authLocalDatasourceProvider = Provider<AuthLocalDatasource>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  final userSessionService = ref.watch(userSessionServiceProvider);
  return AuthLocalDatasource(
    hiveService: hiveService,
    userSessionService: userSessionService,
  );
});

class AuthLocalDatasource implements IAuthLocalDataSource {
  final HiveService _hiveService;
  final UserSessionService _userSessionService;

  AuthLocalDatasource({
    required HiveService hiveService,
    required UserSessionService userSessionService,
  }) : _hiveService = hiveService,
       _userSessionService = userSessionService;

  @override
  Future<UserHiveModel> register(UserHiveModel user) async {
    return await _hiveService.register(user);
  }

  @override
  Future<UserHiveModel?> login(String email, String password) async {
    final user = await _hiveService.login(email, password);
    if (user != null && user.userid.isNotEmpty) {
      await _userSessionService.saveUserSession(
        userId: user.userid,
        name: user.name,
        email: user.email,
        phone: user.phone,
        password: user.password,
      );
      return user;
    } else {
      await _userSessionService.clearSession(); // important
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
      final hiveResult = await _hiveService.logout();
      await _userSessionService.clearSession();
      return hiveResult;
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
