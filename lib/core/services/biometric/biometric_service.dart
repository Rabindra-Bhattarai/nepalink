import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kBiometricEnabled = 'biometric_enabled';
const _kBiometricEmail = 'biometric_email';

final biometricServiceProvider = Provider<BiometricService>((ref) {
  return BiometricService();
});

// Result class so UI knows exactly what happened
class BiometricResult {
  final bool success;
  final String? errorMessage;

  const BiometricResult({required this.success, this.errorMessage});
}

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  /// Check if device hardware supports biometrics
  Future<bool> isAvailable() async {
    try {
      final isDeviceSupported = await _auth.isDeviceSupported();
      final canCheck = await _auth.canCheckBiometrics;
      return isDeviceSupported && canCheck;
    } catch (_) {
      return false;
    }
  }

  /// Get enrolled biometric types on device
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (_) {
      return [];
    }
  }

  /// Check if user has enabled biometric login in the app
  Future<bool> isBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kBiometricEnabled) ?? false;
  }

  /// Enable biometric — scan fingerprint to confirm, then save flag
  Future<BiometricResult> enableBiometric() async {
    try {
      // Step 1: Check hardware support
      final isDeviceSupported = await _auth.isDeviceSupported();
      if (!isDeviceSupported) {
        return const BiometricResult(
          success: false,
          errorMessage:
              'This device does not support biometric authentication.',
        );
      }

      // Step 2: Check if any biometrics are enrolled on the device
      final availableBiometrics = await _auth.getAvailableBiometrics();
      if (availableBiometrics.isEmpty) {
        return const BiometricResult(
          success: false,
          errorMessage:
              'No fingerprint enrolled on this device. Please go to Settings → Security → Fingerprint and add your fingerprint first.',
        );
      }

      // Step 3: Authenticate
      final authenticated = await _auth.authenticate(
        localizedReason: 'Scan your fingerprint to enable biometric login',
        options: const AuthenticationOptions(
          biometricOnly: true, // fingerprint only, no PIN fallback for setup
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );

      if (authenticated) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_kBiometricEnabled, true);
        return const BiometricResult(success: true);
      }

      return const BiometricResult(
        success: false,
        errorMessage: 'Fingerprint not recognised. Please try again.',
      );
    } on PlatformException catch (e) {
      return BiometricResult(
        success: false,
        errorMessage: _mapPlatformError(e),
      );
    } catch (e) {
      return BiometricResult(
        success: false,
        errorMessage: 'Something went wrong. Please try again.',
      );
    }
  }

  /// Disable biometric login
  Future<void> disableBiometric() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kBiometricEnabled, false);
  }

  /// Authenticate using biometrics (used at login screen)
  Future<BiometricResult> authenticate({
    String reason = 'Please authenticate to continue',
  }) async {
    try {
      final available = await isAvailable();
      if (!available) {
        return const BiometricResult(
          success: false,
          errorMessage: 'Biometric not available on this device.',
        );
      }

      final authenticated = await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: false, // allow PIN fallback at login
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );

      return BiometricResult(success: authenticated);
    } on PlatformException catch (e) {
      return BiometricResult(
        success: false,
        errorMessage: _mapPlatformError(e),
      );
    } catch (e) {
      return BiometricResult(
        success: false,
        errorMessage: 'Authentication failed. Please use password.',
      );
    }
  }

  /// Save the email of the user who enabled biometric
  Future<void> saveEmailForBiometric(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kBiometricEmail, email);
  }

  /// Get the saved email for biometric login
  Future<String?> getSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kBiometricEmail);
  }

  /// Cancel ongoing authentication
  Future<void> cancelAuthentication() async {
    try {
      await _auth.stopAuthentication();
    } catch (_) {}
  }

  /// Map platform error codes to human-readable messages
  String _mapPlatformError(PlatformException e) {
    switch (e.code) {
      case auth_error.notEnrolled:
        return 'No fingerprint enrolled. Go to Settings → Security → Fingerprint to add one.';
      case auth_error.notAvailable:
        return 'Biometric authentication is not available on this device.';
      case auth_error.passcodeNotSet:
        return 'No screen lock set. Please set up a PIN or fingerprint in device Settings first.';
      case auth_error.lockedOut:
        return 'Too many failed attempts. Please try again in a moment.';
      case auth_error.permanentlyLockedOut:
        return 'Biometric locked. Please unlock using your device PIN first.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }
}
