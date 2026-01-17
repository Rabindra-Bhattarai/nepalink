import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:nepalink/core/constants/hive_table_constants.dart';
import 'package:nepalink/features/auth/data/models/user_hive_model.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class HiveService {
  // init Hive
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/${HiveTableConstant.dbName}';
    Hive.init(path);

    // register adapter
    _registerAdapter();
    await _openBoxes();
  }

  // register adapters
  void _registerAdapter() {
    if (!Hive.isAdapterRegistered(HiveTableConstant.userTypeId)) {
      Hive.registerAdapter(UserHiveModelAdapter());
    }
  }

  // open boxes
  Future<void> _openBoxes() async {
    await Hive.openBox<UserHiveModel>(HiveTableConstant.userTable);
  }

  // close Hive
  Future<void> close() async {
    await Hive.close();
  }

  // ======================= Auth Queries =========================

  Box<UserHiveModel> get _userBox =>
      Hive.box<UserHiveModel>(HiveTableConstant.userTable);

  // Register user
  Future<UserHiveModel> register(UserHiveModel user) async {
    await _userBox.put(user.userid, user);
    return user;
  }

  // Login - find user by email and password
  Future<UserHiveModel?> login(String email, String password) async {
    try {
      return _userBox.values.firstWhere(
        (user) =>
            user.email.trim().toLowerCase() == email.trim().toLowerCase() &&
            user.password == password.trim(),
      );
    } catch (_) {
      return null;
    }
  }

  // Get user by ID
  UserHiveModel? getUserById(String userid) {
    return _userBox.get(userid);
  }

  // Get user by email
  UserHiveModel? getUserByEmail(String email) {
    try {
      return _userBox.values.firstWhere((user) => user.email == email);
    } catch (e) {
      return null;
    }
  }

  // Get current user (first in box, or null)
  UserHiveModel? getCurrentUser() {
    if (_userBox.isEmpty) return null;
    return _userBox.values.first;
  }

  // Update user
  Future<bool> updateUser(UserHiveModel user) async {
    if (_userBox.containsKey(user.userid)) {
      await _userBox.put(user.userid, user);
      return true;
    }
    return false;
  }

  // Delete user
  Future<void> deleteUser(String userid) async {
    await _userBox.delete(userid);
  }

  // Logout (clear all users)
  Future<bool> logout() async {
    try {
      //do not clear all users here
      return true;
    } catch (e) {
      return false;
    }
  }
}
