import 'package:flutter_riverpod/legacy.dart';
import 'package:nepalink/core/services/biometric/biometric_service.dart';
import 'package:nepalink/features/auth/domain/usecases/login_usecase.dart';
import 'package:nepalink/features/auth/presentation/state/login_state.dart';
import 'package:nepalink/core/services/storage/user_session_service.dart';

class LoginViewModel extends StateNotifier<LoginState> {
  final LoginUsecase _loginUsecase;
  final UserSessionService _sessionService;
  final BiometricService _biometricService;

  LoginViewModel(
    this._loginUsecase,
    this._sessionService,
    this._biometricService,
  ) : super(const LoginState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: LoginStatus.loading);

    final result = await _loginUsecase(
      LoginParams(email: email, password: password),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: LoginStatus.failure,
          errorMessage: failure.message,
        );
      },
      (user) async {
        print("✅ Login success for user: ${user.email}");

        // Save session
        await _sessionService.saveUserSession(
          userId: user.userid,
          name: user.name,
          email: user.email,
          phone: user.phone ?? '',
          password: password,
          profilePic: user.profilePic,
          token: user.token,
          role: user.role,
        );

        // ✅ Save email for biometric login restoration after logout
        await _biometricService.saveEmailForBiometric(email);

        state = state.copyWith(status: LoginStatus.success);
      },
    );
  }

  /// Called from navigation screen for proximity logout
  Future<void> logout() async {
    try {
      await _sessionService.clearSession();
    } catch (_) {}
  }

  /// Called from login screen when biometric auth succeeds
  /// Restores session using saved email + re-fetches from remote
  Future<bool> loginWithBiometric() async {
    state = state.copyWith(status: LoginStatus.loading);

    try {
      final savedEmail = await _biometricService.getSavedEmail();
      if (savedEmail == null || savedEmail.isEmpty) {
        state = state.copyWith(
          status: LoginStatus.failure,
          errorMessage:
              'No saved credentials. Please sign in with email & password first.',
        );
        return false;
      }

      // Restore session from UserSessionService using saved userId
      final userId = _sessionService.getCurrentUserId();
      final token = _sessionService.getToken();

      if (userId != null && token != null && token.isNotEmpty) {
        // Token still exists — just mark as logged in
        state = state.copyWith(status: LoginStatus.success);
        return true;
      }

      // Session was cleared but we still have the email saved
      // We can't re-login without password — tell user to use password once
      state = state.copyWith(
        status: LoginStatus.failure,
        errorMessage:
            'Session expired. Please sign in with email & password once to restore.',
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        status: LoginStatus.failure,
        errorMessage: 'Biometric login failed. Please use password.',
      );
      return false;
    }
  }
}

// Provider
final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, LoginState>((ref) {
      final usecase = ref.read(loginUsecaseProvider);
      final sessionService = ref.read(userSessionServiceProvider);
      final biometricService = ref.read(biometricServiceProvider);
      return LoginViewModel(usecase, sessionService, biometricService);
    });
