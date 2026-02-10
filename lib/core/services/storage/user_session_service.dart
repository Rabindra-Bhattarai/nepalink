import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// SharedPreferences instance provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main.dart');
});

// UserSessionService provider
final userSessionServiceProvider = Provider<UserSessionService>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return UserSessionService(prefs: prefs);
});

class UserSessionService {
  final SharedPreferences _prefs;

  // Keys for storing user data
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserId = 'user_id';
  static const String _keyUserName = 'user_name';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserPhone = 'user_phone';
  static const String _keyUserPassword = 'user_password';
  static const String _keyUserProfilePic = 'user_profile_pic'; //  maps imageUrl
  static const String _keyUserToken = 'user_token';
  static const String _keyUserRole = 'user_role';

  UserSessionService({required SharedPreferences prefs}) : _prefs = prefs;

  /// Save user session after login/registration
  Future<void> saveUserSession({
    required String userId,
    required String name,
    required String email,
    required String phone,
    required String password,
    String? profilePic, //  stores imageUrl filename
    String? token,
    String? role,
  }) async {
    await _prefs.setBool(_keyIsLoggedIn, true);
    await _prefs.setString(_keyUserId, userId);
    await _prefs.setString(_keyUserName, name);
    await _prefs.setString(_keyUserEmail, email);
    await _prefs.setString(_keyUserPhone, phone);
    await _prefs.setString(_keyUserPassword, password);

    if (profilePic != null && profilePic.isNotEmpty) {
      await _prefs.setString(_keyUserProfilePic, profilePic);
    } else {
      await _prefs.setString(
        _keyUserProfilePic,
        "default-profile.png",
      ); // ✅ fallback
    }

    if (token != null && token.isNotEmpty) {
      await _prefs.setString(_keyUserToken, token);
    }
  }

  /// Update only profile picture
  Future<void> updateProfilePic(String profilePic) async {
    await _prefs.setString(_keyUserProfilePic, profilePic);
  }

  /// Update only token
  Future<void> updateToken(String token) async {
    await _prefs.setString(_keyUserToken, token);
  }

  /// Check if user is logged in
  bool isLoggedIn() {
    return _prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  /// Get current user values
  String? getCurrentUserId() => _prefs.getString(_keyUserId);
  String? getCurrentUserName() => _prefs.getString(_keyUserName);
  String? getCurrentUserEmail() => _prefs.getString(_keyUserEmail);
  String? getCurrentUserPhone() => _prefs.getString(_keyUserPhone);
  String? getCurrentUserPassword() => _prefs.getString(_keyUserPassword);
  String? getCurrentUserProfilePic() =>
      _prefs.getString(_keyUserProfilePic); // ✅ returns imageUrl filename
  String? getToken() => _prefs.getString(_keyUserToken);
  String? getRole() => _prefs.getString(_keyUserRole);

  /// Clear user session (logout)
  Future<void> clearSession() async {
    await _prefs.setBool(_keyIsLoggedIn, false);
    await _prefs.remove(_keyUserId);
    await _prefs.remove(_keyUserName);
    await _prefs.remove(_keyUserEmail);
    await _prefs.remove(_keyUserPhone);
    await _prefs.remove(_keyUserPassword);
    await _prefs.remove(_keyUserProfilePic);
    await _prefs.remove(_keyUserToken);
    await _prefs.remove(_keyUserRole);
  }
}
