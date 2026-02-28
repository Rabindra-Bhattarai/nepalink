import 'package:flutter_riverpod/legacy.dart';
import 'package:nepalink/features/auth/domain/usecases/login_usecase.dart';
import 'package:nepalink/features/auth/presentation/state/login_state.dart';
import 'package:nepalink/core/services/storage/user_session_service.dart';

class LoginViewModel extends StateNotifier<LoginState> {
  final LoginUsecase _loginUsecase;
  final UserSessionService _sessionService;

  LoginViewModel(this._loginUsecase, this._sessionService)
    : super(const LoginState());

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

        // Save session with all details including role
        await _sessionService.saveUserSession(
          userId: user.userid, // ✅ use userid from UserEntity
          name: user.name,
          email: user.email,
          phone: user.phone ?? '',
          password: password, // entered password
          profilePic: user.profilePic,
          token: user.token,
          role: user.role, // nurse / member / admin
        );

        state = state.copyWith(status: LoginStatus.success);
      },
    );
  }
}

// Provider
final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, LoginState>((ref) {
      final usecase = ref.read(loginUsecaseProvider);
      final sessionService = ref.read(userSessionServiceProvider);
      return LoginViewModel(usecase, sessionService);
    });
