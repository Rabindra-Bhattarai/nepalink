import 'package:flutter_riverpod/legacy.dart';
import 'package:nepalink/features/auth/domain/usecases/login_usecase.dart';
import 'package:nepalink/features/auth/presentation/state/login_state.dart';

class LoginViewModel extends StateNotifier<LoginState> {
  final LoginUsecase _loginUsecase;

  LoginViewModel(this._loginUsecase) : super(const LoginState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: LoginStatus.loading);

    final result = await _loginUsecase(
      LoginParams(email: email, password: password),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: LoginStatus.failure,
        errorMessage: failure.message,
      ),
      (user) {
        print("Login success for user: ${user.email}");
        state = state.copyWith(status: LoginStatus.success);
      },
    );
  }
}

// Provider
final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, LoginState>((ref) {
      final usecase = ref.read(loginUsecaseProvider);
      return LoginViewModel(usecase);
    });
