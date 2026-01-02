import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main.dart');
});

final userSessionServiceProvider = Provider<UserSessionService>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return UserSessionService(prefs: prefs);
});

class UserSessionService {
  final SharedPreferences _prefs;

  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserName = 'user_name';
  static const String _keyUserPhone = 'user_phone';

  UserSessionService({required SharedPreferences prefs}) : _prefs = prefs;

  Future<void> saveUserSession({
    required String userId,
    required String email,
    required String name,
    required String phone, required String password,
  }) async {
    await _prefs.setBool(_keyIsLoggedIn, true);
    await _prefs.setString(_keyUserId, userId);
    await _prefs.setString(_keyUserEmail, email);
    await _prefs.setString(_keyUserName, name);
    await _prefs.setString(_keyUserPhone, phone);
  }

  bool isLoggedIn() => _prefs.getBool(_keyIsLoggedIn) ?? false;

  String? getCurrentUserId() => _prefs.getString(_keyUserId);
  String? getCurrentUserEmail() => _prefs.getString(_keyUserEmail);
  String? getCurrentUserName() => _prefs.getString(_keyUserName);
  String? getCurrentUserPhone() => _prefs.getString(_keyUserPhone);

  Future<void> clearSession() async {
    await _prefs.remove(_keyIsLoggedIn);
    await _prefs.remove(_keyUserId);
    await _prefs.remove(_keyUserEmail);
    await _prefs.remove(_keyUserName);
    await _prefs.remove(_keyUserPhone);
  }
}
